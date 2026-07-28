#include <iostream>
using namespace std;

int main(void) {
  int number_cents;

  cout << "Digite os centavos(int): ";
  cin >> number_cents;

  cout << "Dollars: " << number_cents / 100 << endl;
  cout << "Quarters: " << (number_cents % 100) / 25 << endl;
  cout << "Dimes: " << ((number_cents % 100) % 25) / 10 << endl;
  cout << "Nickels: " << ((((number_cents % 100) % 25) % 10)) / 5 << endl;
  cout << "Pennies: " << ((((number_cents % 100) % 25) % 10)) % 5 << endl;

  return 0;
}