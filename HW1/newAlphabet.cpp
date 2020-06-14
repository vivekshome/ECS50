//
//  newAlphabet.cpp
//  Vivek Shome
//  Student ID: 916981255
//
#include <iostream>
#include <stdexcept>
#include <string>

int main(int argc, char **argv)
{
	std::string word = "";

	int i = 0, j = 0;
	int num = 0, lettercase = 0;
	int numar[27] = {};

	for(i = 1; i < argc; i++)
	{
		num = std::stoi(argv[i]);

		lettercase = ((num >> (26)) & 0b1);

		for(j = 0; j < 26; j++)
		{
			numar[j] = ((num >> (j)) & 0b1);

			if((numar[j] == 1) && (lettercase == 0))
			{
				word += ('a' + j);
				break;
			}
			else if((numar[j] == 1) && (lettercase == 1))
			{
				word += ('A' + j);				
				break;
			}
			else
			{
				continue;
			}
		}
	}

	std::cout << "You entered the word: " << word << std::endl;
	return 0;
}