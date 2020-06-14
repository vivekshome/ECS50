/*
 *
 * this is for homework 3.3, for ECS 50 Spring 2020
 *
 * Vivek Shome (916981255)
 *
 * version 1	May 12, 2020
 * created program - imported part of code
 *
 * version 2	May 18, 2020
 * recursive function - tried using static variables (to keep track)
 *
 * version 3	May 19, 2020
 * Turns out static variables are not so easy - plus too many registers. So transferring info via the function call
 *
 * version 4	May 20, 2020
 * code cleanup :)
 *
 * version 5 May 21, 2020
 * forgot the / at the beginning of the comment section :/
 *
 */
.global get_combs

.text

#RECURSIVE FUNCTION
recursive:
  
#PROLOGUE
push %ebp
movl %esp, %ebp
subl $4, %esp

.equ num, 8
.equ curr, 12
.equ len_2, 16
.equ k_2, 20
.equ ctr_2, 24
.equ temp_2, 28
.equ return_array,  32
.equ items_2, 36

.equ i, -4 #Local

#if(curr == k_2) - BASE CASE
movl k_2(%ebp), %esi
cmpl curr(%ebp), %esi
jnz else

#for(i = 0; i < k_2; i++)
movl $0, i(%ebp)
for_one_start:
movl i(%ebp), %esi #esi = i
cmpl k_2(%ebp), %esi
jge for_one_end

  #return_array[*ctr_2][i] = temp_2[i]
    
  #temp_2[i]
  movl temp_2(%ebp), %ecx
  movl (%ecx, %esi, 4), %ecx #ECX = temp_2[i]

  #return_array[*ctr_2]
  movl ctr_2(%ebp), %edi
  movl (%edi), %edi #edi = *(&ctr_2)
  movl return_array(%ebp), %eax #EAX = **return_array
  movl (%eax, %edi, 4), %eax
  movl %ecx, (%eax, %esi, 4)  #return_array[*ctr_2][i] = temp_2[i]

  incl i(%ebp) #i++
  jmp for_one_start

for_one_end:

  #(*ctr_2)++ (kinda tough lol)
  movl ctr_2(%ebp), %edi
  movl (%edi), %edi   #edi = *(&ctr_2)
  incl %edi           #edi = *(&ctr_2) + 1
  movl ctr_2(%ebp), %eax
  movl %edi, (%eax)   #(*ctr_2) =  *(&ctr_2) + 1
  jmp recursive_epilogue        #We good to go :)

  
else:
#for (i = num; i < len_2; i++)

movl num(%ebp), %esi
movl %esi, i(%ebp) #i = num; 
for_two_start:
movl i(%ebp), %esi
cmpl len_2(%ebp), %esi
jge for_two_end

  #temp_2[curr] = items_2[i]
  movl items_2(%ebp), %ebx
  movl (%ebx, %esi, 4), %ecx #ECX = items_2[i]
  movl temp_2(%ebp), %eax
  movl curr(%ebp), %edi
  movl %ecx, (%eax, %edi ,4) #temp_2[curr] = ECX

    #recursive function call
    #items_2
    push items_2(%ebp)

    #return_array
    movl return_array(%ebp), %eax
    push %eax #We wanna call by reference

    #temp_2
    push temp_2(%ebp)

    #ctr_2
    push ctr_2(%ebp)

    #k_2
    push k_2(%ebp)

    #len_2
    push len_2(%ebp)

    #++curr
    movl curr(%ebp), %eax
    incl %eax
    push %eax

    #++i
    movl i(%ebp), %esi
    incl %esi
    push %esi

    call recursive
    addl $32, %esp #restore stack pointer    

    incl i(%ebp) #i++
    jmp for_two_start

for_two_end:

recursive_epilogue:
movl return_array(%ebp), %eax
movl %ebp, %esp
pop %ebp
ret

#GET_COMBS
get_combs:

#PROLOGUE
push %ebp
movl %esp, %ebp
subl $16, %esp #make space for locals

.equ items, 8
.equ k, 12
.equ len, 16
.equ ctr, -4 #LOCAL Variables
.equ temp, -8
.equ ret_array_size, -12
.equ ret_array, -16

movl $0, ctr(%ebp)

#ret_array_size = num_combs(len, k)
push k(%ebp)
push len(%ebp)
call num_combs
addl $8, %esp       #restore stack pointer
movl %eax, ret_array_size(%ebp)

#temp[k]
movl k(%ebp), %eax #EAX = k
movl $4, %esi
mull %eax
push %eax
call malloc
addl $4, %esp #restore stack pointer
movl %eax, temp(%ebp)


#ret_array = malloc(sizeof(int*) * ret_array_size);
movl ret_array_size(%ebp), %eax #EAX = number of permutations (ret_array_size)
movl $4, %esi
mull %esi
push %eax
call malloc
addl $4, %esp   #restore stack pointer

movl %eax, ret_array(%ebp)

#for(i = 0; i < ret_array_size; i++)
movl ret_array(%ebp), %ebx
movl $0, %esi # i = 0
init_loop:
  movl k(%ebp), %eax
  movl $4, %ecx
  mull %ecx
  push %eax
  call malloc
  movl k(%ebp), %edi
  movl %eax, (%ebx, %esi, 4) #ret_array[i] = malloc(4 * k) (size of int = 4)
  incl %esi
  cmp ret_array_size(%ebp), %esi
  jl init_loop #There must be at least one elements, so exit-based

  #recursive(0, 0, len, k, p_ctr, temp, ret_array, items);
 
  #items
  push items(%ebp)
  
  #ret_array
  movl ret_array(%ebp), %eax
  push %eax
  
  #temp
  push temp(%ebp)
  
  #ctr
  leal ctr(%ebp), %eax
  push %eax
  
  #k
  push k(%ebp)

  #len
  push len(%ebp)
  
  push $0
  push $0
  call recursive
  addl $32, %esp  #restore stack pointer

#EPILOGUE
movl ret_array(%ebp), %eax   #EAX = return value 
movl %ebp, %esp
pop %ebp
ret
