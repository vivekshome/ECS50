//
//  TriMatMult.cpp
//  Vivek Shome
//  Student ID: 916981255
//
#include <iostream>
#include <stdexcept>
#include <fstream> 
#include <string>
#include <cmath>

int main(int argc, char **argv)
{
	std::ifstream file1(argv[1]);
	std::ifstream file2(argv[2]);

	int i = 0, j = 0, k = 0;
	int sum = 0;
	//int mat1_index = 0, mat2_index = 0, prod_index = 0;
	int size = 0, actualsize = 0;

	std::string temp;

	std::getline(file1, temp);
	std::getline(file2, temp);

	size = (std::stoi(temp) * (std::stoi(temp) + 1))/2; // Using the partial sum of series formula for increased efficiency: n(n+1)/2	

	actualsize = std::stoi(temp);

	int *mat1 = new int[size]; //Dynamic Memory Allocation to create arrays of variable size
	int *mat2 = new int[size];
	int *prod = new int[size];

	i = 0;

	while(!file1.eof())	//Reading values from File 1
	{
		std::getline(file1, temp);
		mat1[i] = std::stoi(temp);
		i++;
	}

	i = 0;

	while(!file2.eof())	//Reading Values from File 2
	{
		std::getline(file2, temp);
		mat2[i] = std::stoi(temp);
		i++;
	}

	for(i = 0; i < actualsize; i++)
	{
		for(j = 0; j < actualsize; j++)
		{					
			sum = 0;
			k = 0;

			if(i <= j)
			std::cout << mat1[actualsize*(actualsize - 1)/2 - (actualsize - i)*(actualsize - i - 1)/2 + j] << " ";
		else
			std::cout << "0 ";

		}
		std::cout << std::endl;				
	}

	for(i = 0; i < size; i++)
	{		
		std::cout << prod[i] << std::endl;
	}
}
