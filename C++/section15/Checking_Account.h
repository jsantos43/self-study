#ifndef CHECKING_ACCOUNT_H
#define CHECKING_ACCOUNT_H

#include "Account.h"
#include <string>

class Checking_Account : public Account {
  private:
    static constexpr const char *def_name = "No Name";
    static constexpr double def_balance = 50;
  public:
    Checking_Account(std::string name = def_name, double balance = def_balance);
    bool withdraw(double);
};

#endif