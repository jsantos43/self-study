#include "Trust_Account.h"

Trust_Account::Trust_Account(std::string name, double balance)
  : Account(name, balance), total_withdraws(0) {

}

bool Trust_Account::deposit(double amount) {
  if (amount >= 5000) {
    return Account::deposit(amount + 50);
  } else {
    return Account::deposit(amount);
  }
}

bool Trust_Account::withdraw(double amount) {
  if (total_withdraws < 3 && amount <= (balance * 0.2)) {
    if (Account::withdraw(amount)) {
      total_withdraws++;
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}