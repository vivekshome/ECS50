/*
 *
 * this is for homework 2.3, for ECS 50 Winter 2020
 *
 * Vivek Shome (916981255)
 * version 1	April 21, 2020
 * converted program from C to Assembly
 *
 * version 2	April 21, 2020
 * fixed errors, swapped the if-else condition as that was causing extra bit shifts. Removed extra addl
 *
 */
.global _start

.data
dividend:			#Creating a 4-byte space for dividend
	.long 15

divisor:			#Creating a 4-byte space for divisor
	.long 7

.text

_start:
#EAX holds quotient
#EDX holds remainder

movl $0, %edx
movl $0, %eax
movl $0, %ebx #EBX is used to store temporary values

movl $31, %ecx # i = 31
for_start:
cmpl $0, %ecx
jl for_end 	# i < 0
	movl dividend, %ebx
	shrl %cl, %ebx # shift ebx right by cl (i)
	cmpl %ebx, divisor #check if divisor is greater than (dividend >> i)
	jg end_else #if yes, then go to end_else
		movl divisor, %ebx
		shll %cl, %ebx 	#shifting the divisor left by i
		subl %ebx, dividend #subtracting (divisor << 1) from the dividend
		shll $1, %eax #quotient << 1
		addl $0b1, %eax #quotient += 0b1
		jmp for_dec #jump outside the if-else, and decrement the counter

	end_else:
	shll $1, %eax #quotient << 1
	
	for_dec:
	decl %ecx #i--

jmp for_start

for_end:
	movl dividend, %edx #edx = dividend


done: 				#all good!
	nop
	