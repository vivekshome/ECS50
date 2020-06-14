//
//  scientificFloating.cpp
//  Vivek Shome
//  Student ID: 916981255
//
#include <iostream>
#include <stdexcept>
#include <string>
#include <cmath>

int main(void)
{
	float num = 0;
	unsigned int float_int = 0;
	int sign = 0, exp = 0, mant = 0;
	int rem = 0, exp_pow = 0, numzero = 0, i = 0;

	std::string mant_bin;

	std::cout << "Please enter a float: ";
	std::cin >> num;

	float_int = *((unsigned int*)&num); //Casting to Integer

	sign = ((float_int >> (31)) & 0b1);	//Field Extraction
	exp = ((float_int >> (23)) & 0b11111111);
	mant = ((float_int >> (0)) & 0b11111111111111111111111);


	if(exp == 128) //Checking for special case
	{
		if(mant == 0)
		{
			std::cout << "infinity" << std::endl;
			return 0;
		}
		else if(mant != 0)
		{
			std::cout << "NaN" << std::endl;
			return 0;
		}
	}
	else if(exp == 0)	//Checking for Special Case (if the number is 0)
	{
		if(sign == 0)
		{
			std::cout << "0E0" << std::endl;
			return 0; 
		}
		else if(sign == 1)
		{
			std::cout << "-0E0" << std::endl;
			return 0;
		}
	}	
	else if(exp != 0)
	{
		exp_pow = exp - 127;
	}	
	
	while(mant != 0)	//Converting Mantissa to Binary
	{
		rem = mant % 2;
		mant_bin = std::to_string(rem) + mant_bin;
		mant /= 2;
	}

	while(mant_bin.length() != 23)	//Adding leading zeros (if necessary)
	{
		mant_bin = '0' + mant_bin;
	}

	i = mant_bin.length() - 1;

	while(mant_bin[i] == '0') //Counting trailing zeros
	{
		numzero++;
		i--;
	}

	if(numzero != 0)	//Removing trailing zeros
	{
		mant_bin.erase((i+1), numzero);
	}

	if(!mant_bin.empty())	//If Mantissa is not empty, add decimal point before it.
	{
		mant_bin = '.' + mant_bin;
	}
	
	if(sign == 0)
	{
		std::cout << "1" << mant_bin << "E" << exp_pow << std::endl; 
	}
	else if(sign == 1)
	{
		std::cout << "-1" << mant_bin << "E" << exp_pow << std::endl; 
	}
	
}
