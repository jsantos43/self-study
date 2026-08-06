#include <iostream>
#include <vector>
using namespace std;

void print_menu();
char ask_option();
void print_numbers(vector <int>);
void add_number(vector <int> &list);
void display_mean(vector <int>);
void display_smallest(vector <int>);
void display_largest(vector <int>);

void print_menu() {
  cout << "\n\n";
  cout << "P - Print numbers" << endl;
  cout << "A - Add a number" << endl;
  cout << "M - Display mean of the numbers" << endl;
  cout << "S - Display the smallest number" << endl;
  cout << "L - Display the largest number" << endl;
  cout << "Q - Quit" << endl;
}

char ask_option() {
  char letter;

  cout << endl << "Enter your choice: ";
  cin >> letter;

  return toupper(letter);
}

void print_numbers(vector <int> list) {
  cout << "[";

  for (int element: list) {
    cout << " " << element << " "; 
  }

  cout << "]" << endl;
}

void add_number(vector <int> &list) {
  int number{0};

  cout << "Enter a number to add in list: ";
  cin >> number;
  list.push_back(number);
  cout << number << " added in list" << endl;
}

void display_mean(vector <int> list) {
  int sum_list{0}, avarage{0};

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
}

void display_smallest(vector <int> list) {
  int smallest_number{0};

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
}

void display_largest(vector <int> list) {
  int largest_number{0};

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
}

int main(void) {
  vector <int> list;
  char option;
  bool exit {false};
  
  do {
    print_menu();
    option = ask_option();

    switch(option) {
      case 'Q':
        exit = true;
        break;
      case 'P':
        print_numbers(list);
        break;
      case 'A':
        add_number(list);
        break;
      case 'M':
        display_mean(list);
        break;
      case 'S':
        display_smallest(list);
        break;
      case 'L':
        display_largest(list);
        break;
      default:
        cout << "Unknow selection, please try again!" << endl;
    }
  } while (!exit);

  cout << endl << "Goodbye!" << endl;

  return 0;
}