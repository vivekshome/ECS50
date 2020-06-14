/*
 *
 * this is for homework 2.1, for ECS 50 Winter 2020
 *
 * Vivek Shome (916981255)
 * version 1	April 20, 2020
 * wrote the program
 *
 */
.global _start

.data
num1:			#Creating a 64-bit number num1
	.long 10
	.long 20	
num2:			#Creating a 64-bit number num2
	.long 12
	.long 24

.text

_start:
#EAX holds lower 32 bits of sum
#EDX holds upper 32 bits of sum

movl num1, %edx 	#upper 32 bits of num1 are moved to EDX
movl num1+4, %eax 	#lower 32 bits of num1 are moved to EAX (We use num1 + 4 to access the lower 32 bits (since long takes 4 bytes of space))
addl num2+4, %eax 	#add lower 32 bits of num2 to EAX (If there is any carry, the carry flag is toggled to 1)
adcl num2, %edx 	#adds num2 and the carry flag to EDX. EDX + num2 + carry flag


done: 				#all good!
	nop
	