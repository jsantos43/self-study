#include "Checking_Account.h"

Checking_Account::Checking_Account(std::string name, double balance)
  : Account(name, balance) {

}

bool Checking_Account::withdraw(double amount) {
  if (balance < 1.5) {
    return false;
  }

  return Account::withdraw(amount + 1.5);
}