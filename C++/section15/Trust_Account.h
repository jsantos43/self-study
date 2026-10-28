#ifndef TRUST_ACCOUNT_H
#define TRUST_ACCOUNT_H

#include "Account.h"
#include <string>

class Trust_Account : public Account {
  private:
    static constexpr const char *def_name = "No Name";
    static constexpr double def_balance = 100;
    static constexpr double bonus = 50;
  protected:
    int total_withdraws;
  public:
    Trust_Account(std::string name = def_name, double balance = def_balance);
    bool deposit(double);
    bool withdraw(double);
};

#endif