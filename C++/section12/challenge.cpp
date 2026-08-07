#include <iostream>
using namespace std;

int *apply_all(int [], size_t, int [], size_t);
void print(int [], size_t);

int *apply_all(int array1 [], size_t size1, int array2 [], size_t size2) {
  int *new_array = new int[size1 * size2];

  for (size_t index{0}; index < size2; index++) {
    for (size_t index2{0}; index2 < size1; index2++) {
      new_array[(size1 * index) + index2] = array1[index2] * array2[index];
    }
  }

  return new_array;
}

void print(int array [], size_t size) {
  cout << " [ ";

  for (size_t index{0}; index < size; index++) {
    cout << array[index] << " ";
  }

  cout << "]" << endl;
}

int main(void) {
  int array1[] {1,2,3,4,5};
  int array2[] {10,20,30};

  cout << "Array1: ";
  print(array1, 5);

  cout << "Array2: ";
  print(array2, 3);

  int *results = apply_all(array1, 5, array2, 3);
  cout << "Result: ";
  print(results, 15);

  delete [] results;

  return 0;
}