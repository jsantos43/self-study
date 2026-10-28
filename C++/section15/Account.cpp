#include "Account.h"

Account::Account(std::string name, double balance)
  : name(name), balance(balance) {

}

Account::~Account() {

};

double Account::get_balance() {
  return balance;
}

bool Account::deposit(double amount) {
  if (amount <= 0) {
    return false;
  } else {
    balance += amount;
    return true;
  }
}

bool Account::withdraw(double amount) {
  if (amount <= 0 || (balance - amount) < 0) {
    return false;
  } else {
    balance -= amount;
    return true;
  }
}

std::ostream& operator<<(std::ostream& output, const Account& acc) {
  output << "[Name: " << acc.name << " | Balance: " << acc.balance << "]";
  return output; 
}
