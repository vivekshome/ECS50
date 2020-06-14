#include <stdio.h>
#include <stdlib.h>
#include "combs.h"

void print_mat(int** mat, int num_rows, int num_cols);
void free_mat(int** mat, int num_rows, int num_cols);

static int index = 0;

int max(int a, int b){
  return a > b ? a : b;
}

int min(int a, int b){
  return a < b ? a : b;
}

int num_combs(int n, int k){
  int combs = 1;
  int i;
  
  for(i = n; i > max(k, n-k); i--){
    combs *= i;
  }

  for(i = 2; i <= min(k, n - k); i++){
    combs /= i;
  }
  
  return combs;

}

void print_mat(int** mat, int num_rows, int num_cols){
  int i,j;
  
  for(i = 0; i < num_rows; i++){
    for( j = 0; j < num_cols; j++){
      printf("%d ", mat[i][j]); 
    }
    printf("\n");
  }
}

void free_mat(int** mat, int num_rows, int num_cols){
  int i;
  
  for(i = 0; i < num_rows; i++){
    free(mat[i]);
  }
  free(mat);
}

void swap(int *x, int *y) 
{ 
    int temp; 
    temp = *x; 
    *x = *y; 
    *y = temp; 
} 
  
/* Function to print permutations of string 
   This function takes three parameters: 
   1. String 
   2. Starting index of the string 
   3. Ending index of the string. */
void permute(int *item_1, int start, int end, int **ret_array, int k_2) 
{ 
   int i;
   int *temp; 
   if(start == end)
   {
   	if(index < 10)
   	{
   	 for(i = 0; i < k_2; i++)
   	 {
   	 	ret_array[index][i] = item_1[i];
   	 }
   	 index++;
   	}
     return; 
	}   
   else
   { 
       for (i = start; i <= end; i++) 
       {           
          temp = item_1[i];
          item_1[i] = item_1[start];
          item_1[start] = temp;

          permute(item_1, start + 1, end, ret_array, k_2); 
                    
          temp = item_1[i];
          item_1[i] = item_1[start];
          item_1[start] = temp;
       } 
   } 
} 

int** get_combs(int* items, int k, int len)
{
  int ctr = 0, ret_array_size;

  ret_array_size = num_combs(len, k);  

  int** ret_array = malloc(ret_array_size * 4);
  int* temp = malloc(ret_array_size * 4);

  for(int i = 0; i < ret_array_size; i++)
  {
      ret_array[i] = malloc(k * 4);
  }

  permute(items, 0, len - 1, ret_array, k);

  return ret_array;
}

int main(){
  int num_items;
  int* items; 
  int i,k;
  int** combs;
  printf("How many items do you have: ");
  scanf("%d", &num_items);
  
  items = (int*) malloc(num_items * sizeof(int));
  
  printf("Enter your items: ");
  for(i = 0; i < num_items; i++){
    scanf("%d", &items[i]);
  } 
  
  printf("Enter k: ");
  scanf("%d", &k);
  
  combs = get_combs(items, k, num_items);
  print_mat(combs,num_combs(num_items, k) ,k);
  free(items);
  free_mat(combs,num_combs(num_items, k), k);
  
  return 0;
}
