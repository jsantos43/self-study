#include <iostream>
#include <vector>
using namespace std;

int main(void) {
  vector <int>list;

  char letter;
  int number{0};
  int sum_list{0}, avarage{0};
  int largest_number{0}, smallest_number{0};
  
  while(true) {
    cout << "\n\n";
    cout << "P - Print numbers" << endl;
    cout << "A - Add a number" << endl;
    cout << "M - Display mean of the numbers" << endl;
    cout << "S - Display the smallest number" << endl;
    cout << "L - Display the largest number" << endl;
    cout << "Q - Quit" << endl;

    cout << endl << "Enter your choice: ";
    cin >> letter;

    if (letter == 'q' || letter == 'Q') {
      break;
    }

    switch(letter) {
      case 'p':
      case 'P':
        cout << "[";
        for (auto element: list) {
          cout << " " << element << " "; 
        }
        cout << "]" << endl;
        break;
      case 'a':
      case 'A':
        cout << "Enter a number to add in list: ";
        cin >> number;
        list.push_back(number);
        cout << number << " added in list" << endl;
        break;
      case 'm':
      case 'M':
        if (list.size() != 0) {
          sum_list = 0;
          for (auto element: list) {
            sum_list += element;
          }

          avarage = static_cast<int>(sum_list) / list.size();

          cout << "The avarage is " << avarage << endl;
        } else {
          cout << "Unable to calculate the mean - no data";
        }
        break;
      case 's':
      case 'S':
        if (list.size() != 0) {
          smallest_number = list.at(0);
          for (auto element: list) {
            if (element < smallest_number) {
              smallest_number = element;
            }
          }

          cout << "The smallest number is " << smallest_number << endl;
        } else {
          cout << "Unable to determine the smallest number - list is empty";
        }
        break;
      case 'l':
      case 'L':
        if (list.size() != 0) {
          largest_number = list.at(0);
          for (auto element: list) {
            if (element > largest_number) {
              largest_number = element;
            }
          }

          cout << "The largest number is " << largest_number << endl;
        } else {
          cout << "Unable to determine the largest number - list is empty";
        }

        break;
      default:
        cout << "Unknow selection, please try again" << endl;
    }
  }

  cout << endl << "Goodbye" << endl;

  return 0;
}