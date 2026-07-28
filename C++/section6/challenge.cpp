#include <iostream>
using namespace std;

int main(void) {
  int small_rooms, large_rooms;
  const int price_small{25}, price_large{35};
  cout << "Estimate for carpet cleaning service" << endl;
  cout << "Number of small rooms: ";
  cin >> small_rooms;
  cout << "Number of large rooms: ";
  cin >> large_rooms;
  cout << "Price per small room: $" << price_small << endl;
  cout << "Price per small room: $" << price_large << endl;

  double cost = small_rooms * price_small + large_rooms * price_large;
  double tax = cost * 0.06;

  cout << "Cost: $" << cost << endl;
  cout << "Tax: $" <<  tax << endl;

  cout << "\n========================\n";
  cout << "Total estimate: $" << cost + tax << endl;
}