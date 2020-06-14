/*
 *
 * this is for homework 3.2, for ECS 50 Spring 2020
 *
 * Vivek Shome (916981255)
 *
 * version 1	May 13, 2020
 * created program - converted from C to x86
 *
 * version 2	May 13, 2020
 * fixed errors - now using unsigned jump statements. There was also an error where the if condition was NOT negated (oops). Improved documentation and cleaned up the code.
 *
 */
.global knapsack

.equ weights, 8
.equ values, 12
.equ num_items, 16
.equ capacity, 20
.equ cur_value, 24
.equ best_value, -4 #local variables

.text

knapsack:

#PROLOGUE
push %ebp
movl %esp, %ebp
subl $4, %esp #making space for local variables.
push %esi #used a register to make the counter variable easier to handle

movl cur_value(%ebp), %eax
movl %eax, best_value(%ebp) #best_value = cur_value

movl $0, %esi
for_start:
cmpl num_items(%ebp), %esi # i < num_items
jae for_end
	
	movl weights(%ebp), %ecx		
	movl capacity(%ebp), %edx

	#If Statement
	cmpl (%ecx, %esi, 4), %edx #capacity - weights[i] >= 0
	jb if_end

		#cur_value + values[i]
		movl cur_value(%ebp), %ecx	#ECX = cur_value
		movl values(%ebp), %eax #EAX = values
		leal (%eax, %esi, 4), %eax #EAX = &values[i]
		addl (%eax), %ecx #ECX = cur_value + values[i]
		push %ecx	

		#capacity - weights[i]
		movl capacity(%ebp), %ecx	#ECX = capacity
		movl weights(%ebp), %eax #EAX = weights
		leal (%eax, %esi, 4), %eax #EAX = &weights[i]
		subl (%eax), %ecx #ECX = capacity - weights[i]
		push %ecx

		#num_items - i - 1
		movl num_items(%ebp), %ecx
		subl %esi, %ecx
		decl %ecx
		push %ecx

		#values + i + 1
		movl values(%ebp), %ecx
		movl %esi, %edx
		incl %edx
		leal (%ecx, %edx, 4), %ecx
		push %ecx

		#weights + i + 1
		movl weights(%ebp), %ecx
		movl %esi, %edx
		incl %edx
		leal (%ecx, %edx, 4), %ecx
		push %ecx


		call knapsack #recursive function call
		addl $20, %esp #restoring stack pointer

		movl best_value(%ebp), %ecx
		
		cmpl %ecx, %eax #EAX < ECX
		jae max_set
			movl %ecx, %eax
		max_set:
		movl %eax, best_value(%ebp) #best_value = max(best_value, knapsack(weights + i + 1, values + i + 1, num_items - i - 1, capacity - weights[i], cur_value + values[i]))

	if_end:
		incl %esi #i++
		jmp for_start

for_end:
	movl best_value(%ebp), %eax #EAX = best_value (its for the callee function)

#EPILOGUE
pop %esi
movl %ebp, %esp
pop %ebp
ret
