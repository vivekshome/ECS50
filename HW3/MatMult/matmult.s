/*
 *
 * this is for homework 3.1, for ECS 50 Spring 2020
 *
 * Vivek Shome (916981255)
 *
 * version 1	May 12, 2020
 * created program - imported part of code
 *
 * version 2	May 13, 2020
 * fixed segfault - malloc was changing the value of ECX to something funky, which we were using to store C. Fixed it by redeclaring ECX = c after the malloc.
 * cleaned up code, increased documentation
 *
 * version 3	May 13, 2020
 * fixed ANOTHER segfault - turned out code was faulty since third loop used num_rows_a instead of num_cols_a. Never trust copy-paste, and ALWAYS re-review your code. phew.
 *
 */
.global matMult

.equ a, 8
.equ num_rows_a, 12
.equ num_cols_a, 16
.equ b, 20
.equ num_rows_b, 24
.equ num_cols_b, 28
.equ c, -4 #local variables
.equ i, -8
.equ j, -12
.equ k, -16
.equ sum, -20

.text

matMult:

#PROLOGUE
push %ebp
movl %esp, %ebp
subl $20, %esp #making space for local variables. Tried not to use additional registers for maximum efficiency.

#MEMORY ALLOCATION FOR MATRIX C - code imported from matadd.s (Google Drive) and modified + simplified
movl num_rows_a(%ebp), %eax #EAX = num_rows_a
movl $4, %ecx
mull %ecx #EAX = num_rows_a * size(int*)
push %eax
call malloc

addl $4, %esp #Restoring Stack Pointer

movl %eax, c(%ebp) #save C to the Stack

movl $0, i(%ebp) #i = 0

matrix_init_for:
movl num_rows_a(%ebp), %edx
cmpl %edx, i(%ebp)
jge	matrix_init_for_end
	movl num_cols_b(%ebp), %eax #EAX = num_cols_b
	movl $4, %edx
	mull %edx #EAX = num_rows_a * size(int*)
	push %eax
	call malloc
	movl c(%ebp), %ecx
	movl i(%ebp), %edx
	movl %eax, (%ecx, %edx, 4) #c[i] = int* (creating array of arrays)
	incl i(%ebp)	#i++
	jmp matrix_init_for
matrix_init_for_end:
	addl $4, %esp #Restoring Stack Pointer


#MULTIPLICATION OF ELEMENTS
movl $0, i(%ebp) #i = 0
multiplication_loop_one:
movl num_rows_a(%ebp), %edx
cmpl %edx, i(%ebp) #i < num_rows_a
jge multiplication_loop_one_end
		
	movl $0, j(%ebp) #j = 0
	multiplication_loop_two:
	movl num_cols_b(%ebp), %edx
	cmpl %edx, j(%ebp) #j < num_cols_a
	jge multiplication_loop_two_end

		movl $0, sum(%ebp) #sum = 0

		movl $0, k(%ebp) #k = 0
		multiplication_loop_three:
		movl num_cols_a(%ebp), %edx
		cmpl %edx, k(%ebp) #k < num_cols_a
		jge multiplication_loop_three_end

			#EAX = a[i][k]
			movl a(%ebp), %ecx
			movl i(%ebp), %edx
			movl (%ecx, %edx, 4), %ecx 
			movl k(%ebp), %edx
			movl (%ecx, %edx, 4), %eax

			#EDX b[k][j]
			movl b(%ebp), %ecx
			movl k(%ebp), %edx
			movl (%ecx, %edx, 4), %ecx
			movl j(%ebp), %edx
			movl (%ecx, %edx, 4), %ecx

			mull %ecx
			addl %eax, sum(%ebp) #sum = eax = a[i][k] * b[k][j]

			incl k(%ebp) #k++
			jmp multiplication_loop_three

		multiplication_loop_three_end:

		#c[i][j] = sum
		movl sum(%ebp), %ecx #ecx = sum
		movl c(%ebp), %eax   #EAX = C

		movl i(%ebp), %edx #edx = i
		movl (%eax, %edx, 4), %eax #EAX = c[i]
		movl j(%ebp), %edx #edx = j
		movl %ecx, (%eax, %edx, 4) #c[i][j] = ECX = Sum
			
		incl j(%ebp) #j++
		jmp multiplication_loop_two

	multiplication_loop_two_end:

	incl i(%ebp) #i++
	jmp multiplication_loop_one

multiplication_loop_one_end:
movl c(%ebp), %eax #EAX = c

#EPILOGUE
movl %ebp, %esp
pop %ebp
ret
