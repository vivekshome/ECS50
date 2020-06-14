//
//  TriMatMult.cpp
//  Vivek Shome and Abhirup Dutta
//  Group 10
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
	int mat1_index = 0, mat2_index = 0, prod_index = 0;
	int size = 0, compressedSize = 0;

	std::string temp;

	std::getline(file1, temp);
	std::getline(file2, temp);

	size = std::stoi(temp);
	compressedSize = (size * (size + 1))/2; // Using the partial sum of series formula for increased efficiency: n(n+1)/2 

	int *mat1 = new int[compressedSize]; //Dynamic Memory Allocation to create arrays of variable size
	int *mat2 = new int[compressedSize];
	int *prod = new int[compressedSize];

	while(!file1.eof())	//Reading values from File 1
	{
		std::getline(file1, temp);

		if(!temp.empty())
		{
			mat1[i] = std::stoi(temp);
		}		

		i++;
	}

	i = 0;

	while(!file2.eof())	//Reading Values from File 2
	{
		std::getline(file2, temp);
		
		if(!temp.empty())
		{
			mat2[i] = std::stoi(temp);
		}

		i++;
	}

	for(i = 0; i < size; i++)
	{
		for(j = 0; j < size; j++)
		{		
			prod_index = (size*(size - 1) - (size - i)*(size - i - 1))/2 + j; //Converting 2D Array Address to 1D Address (Taking into consideration it is an Upper Triangular Matrix)
			sum = 0;

			for(k = 0; k < size; k++)
			{				
				 mat1_index = (size*(size - 1) - (size - i)*(size - i - 1))/2 + k;
				 mat2_index = (size*(size - 1) - (size - k)*(size - k - 1))/2 + j;
				 
				 if((i <= k) && (k <= j))
				 {
				 	sum += (mat1[mat1_index] * mat2[mat2_index]);
				 }
			}
			if(i <= j)
			{
				prod[prod_index] = sum;
			}			
		}				
	}

	for(i = 0; i < compressedSize; i++)
	{		
		std::cout << prod[i] << " ";
	}

	std::cout << std::endl;

	return 0;
}
