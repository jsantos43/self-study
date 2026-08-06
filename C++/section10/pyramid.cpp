#include <iostream>
#include <string>
#include <cstring>
using namespace std;

int main(void) {
  string letters;

  cout << "Enter the characters to perform a pyramid: ";
  cin >> letters;
  
  cout << "\nSee the pyramid: \n\n";
  
  string pyramid;
  
  int pyramid_length{};
  for (size_t index{0}; index < letters.length(); index++) {
    if (index != 0) {
      // Make pyramid lines
      pyramid_length += 2;
      
      pyramid.insert(pyramid_length - index - 2, 1, letters.at(index - 1));
      pyramid.insert(index, 1, letters.at(index));
    } else {
      pyramid_length = 1;
      pyramid += letters.at(0);
    }

    // Print spaces
    for (size_t counter{0}; counter < letters.length() - index - 1; counter++) {
      cout << " ";
    }

    // Print pyramid line
    cout << pyramid << endl;
  }

  return 0;
}