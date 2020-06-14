/*
 *
 * this is for homework 2.4, for ECS 50 Spring 2020
 *
 * Vivek Shome (916981255)
 * version 1	April 27, 2020
 * converted program from C to Assembly
 *
 * version 2	April 28, 2020
 * changed registers (could not use %esi, %edi as temporary registers since we cannot use cmpb (they cannot be used as 8-bit registers))
 * fixed an error where value of EDX was not updated to -4 (have to keep track of registers!)
 * improved documentation
 *
 */
.global _start

.data
string1:
	.space 100

string2:		
	.space 100

string1_len:
	.long 0

string2_len:
	.long 0

oldDist:
	.space 400

curDist:
	.space 400

min_value_1:
	.long 0

min_value_2:
	.long 0



.text

find_min:
	movl min_value_2, %eax 	#EAX = min_value_2
	cmpl min_value_1, %eax  #min_value2_2 - min_value_1
	jg find_min_1
		movl min_value_2, %edx #min_value_2 is the greater value
		ret #return
	find_min_1:
		movl min_value_1, %edx #min_value_1 is the greater value
		ret

swap:
	movl $0, %ecx #initialize registers, i = 0
	movl $0, %edx
	movl $0, %ebx

	swap_for_start:
	cmpl $100, %ecx #for i < 100
	jg swap_for_end 
		movl oldDist(, %ecx, 4), %edx #temporary registers EDX = oldDist[i]
		movl curDist(, %ecx, 4), %ebx # EBX = curDist[i]

		movl %ebx, oldDist(, %ecx, 4) #oldDist[i] = EBX = curDist[i]
		movl %edx, curDist(, %ecx, 4) #curDist[i] = EDX = oldDist[i]
		incl %ecx #i++
		jmp swap_for_start
	
	swap_for_end:
		movl $0, %edx
		movl $0, %ebx
		movl $0, %ecx
		ret #return

#strlen imported from Google Drive Example - Subroutines
strlen: #(char* str)
	#ecx will be str
	#ebx will be len which is also the return value
	
	#for(len = 0; str[len] != '\0'; ++len);

	movl $0, %ebx # len = 0
	
	for_start:
		#str[len] != '\0'
		#str[len] -'\0' != 0
		#neg: str[len] -'\0' == 0
		#*(str + len) -'\0' == 0
		cmpb $0, (%ecx, %ebx) #str[len] - '\0'
		jz for_end 
		incl %ebx
		jmp for_start
	for_end:
	ret
	

_start:
	movl $string1, %ecx #ecx = &String1
	call strlen #calling strlen function for string1
	movl %ebx, string1_len #string1_len = EBX

	movl $string2, %ecx #ditto as above
	call strlen
	movl %ebx, string2_len

	movl $0, %esi # i = ESI = 0
	movl $0, %eax #distance = EAX = 0

	init_dist_for_start:
		cmpl string2_len, %esi #for(i < str2_length + 1)
		jg init_dist_for_end
			movl %esi, oldDist(, %esi, 4) #oldDist[i] = i
			movl %esi, curDist(, %esi, 4) #curDist[i] = i
			incl %esi #i++
		jmp init_dist_for_start
	init_dist_for_end:

	movl $1, %esi #i = 1
	outer_for_start:
		cmpl string1_len, %esi #for(i < str1_length + 1)
		jg outer_for_end
			movl %esi, curDist #curDist[0] = i

			movl $1, %edi #j = 1
			inner_for_start:
				cmpl string2_len, %edi #for(j < str2_length + 1)
				jg inner_for_end
					if_start:
					movl $-1, %edx #EDX = -1
					movb string2(%edx, %edi, 1), %cl #CL = string2[j - 1]
					cmpb string1(%edx, %esi, 1), %cl #if(string2[i-1] == string1[j-1])					
					jnz else
						movl $-4, %edx
						movl oldDist(%edx, %edi, 4), %ecx 
						movl %ecx, curDist(, %edi, 4) #curDist[j] = oldDist[j-1]
						jmp if_end
					else:
					movl $-4, %edx
						movl oldDist(, %edi, 4), %ecx
						movl %ecx, min_value_1
						movl curDist(%edx, %edi, 4), %ecx
						movl %ecx, min_value_2						
						call find_min

						movl %edx, min_value_1
						movl $-4, %edx #put EDX = -4 for indexing, since EDX has changed value due to find_min subroutine
						movl oldDist(%edx, %edi, 4), %ecx
						movl %ecx, min_value_2 
						call find_min #find min of oldDist[j], oldDist[j-1], and curDist[j-1]

						movl %edx, curDist(, %edi, 4) #curDist[j] = min (EDX)
						incl curDist(, %edi, 4) #curDist[j]++

					if_end:
						incl %edi #j++
						jmp inner_for_start

				inner_for_end:
					call swap #swap curDist and oldDist
					incl %esi #i++
					jmp outer_for_start

	outer_for_end:
		movl string2_len, %ebx #EBX = string2_length
		movl oldDist(, %ebx, 4), %eax #EAX = oldDIst[strin2_length]


done:	#all good!
	nop
