//
//  changeOfBase.cpp
//  Vivek Shome
//  Student ID: 916981255
//
#include <iostream>
#include <stdexcept>
#include <string>
#include <cmath>

int main(void)
{
	int oldbase, newbase;
	int sum = 0, rem = 0, i = 0;
	char ch;

	std::string oldnum;
	std::string newnum = "";

	std::cout << "Please enter the number's base: ";
	std::cin >> oldbase;

	std::cout << "Please enter the number: ";
	std::cin >> oldnum;

	std::cout << "Please enter the new base: ";
	std::cin >> newbase;

	if((oldbase < 2) || (oldbase > 36) || (newbase < 2) || (newbase > 36))
	{
		return 1;
	}
	else
	{
	if(oldbase != 10)
	{
		for(i = (oldnum.length() - 1); i >= 0; i--)
		{
			if(isdigit(oldnum[i]))
			{				
				sum += (((int)oldnum[i] - 48)*pow(oldbase, (oldnum.length() - 1 - i)));
			}
			else if(isalpha(oldnum[i]))
			{
				sum += (((int)oldnum[i] - 55)*pow(oldbase, (oldnum.length() - 1 - i)));
			}
		}
	}	
	else
	{
		sum = std::stoi(oldnum);
	}		

	while(sum != 0)
	{
		rem = sum % newbase;

		if(rem  < 10)
		{
			ch = '0' + rem;
		}
		else
		{
			ch = 'A' + (rem - 10); 
		}

		newnum = ch + newnum;

		sum /= newbase;
	}

	std::cout << oldnum << " base " << oldbase << " is " << newnum << " base " << newbase << std::endl;
	return 0;
}
}