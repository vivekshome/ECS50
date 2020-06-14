/*
 *
 * this is for homework 2.2, for ECS 50 Winter 2020
 *
 * Vivek Shome (916981255)
 * version 1	April 20, 2020
 * wrote the program
 *
 * version 2	April 20, 2020
 * ensured that dividend and divisor are UNSIGNED
 *
 * version 3	April 21, 2020
 * Fixed the edge case (Test 6) on Mimir, narrowed the error down to the atoi() function which was causing integer wraparound. Using typecasted strtoul() now
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int agrc, char **argv)
{
	unsigned int dividend = (unsigned int)strtoul(argv[1], 0, 10);
	unsigned int divisor = (unsigned int)strtoul(argv[2], 0, 10);	

	unsigned int q = 0, i = 0;

	for(i = 31; i >= 0; i--) //O(1) complexity since it is a loop with fized no. of iterations (32)
	{
		if(divisor <= (dividend >> i)) //checking if the first 'i' bits of the dividend are divisible by the divisor
		{	
			dividend -= (divisor << i); //subtracting the divisor from the first 'i' bits of the dividend
			q = (q << 1) + 0b1; //appending 1 to the quotient (in binary)
		}
		else
		{
			q = (q << 1) + 0b0; //appending 0 to the quotient (in binary)
		}
	}

	printf("%s / %s = %d R %d\n", argv[1], argv[2], q, dividend);
	return 0;	//All Good!
}