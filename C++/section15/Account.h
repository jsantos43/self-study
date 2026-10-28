#ifndef ACCOUNT_H
#define ACCOUNT_H

#include <ostream>
#include <string>

class Account {
  friend std::ostream& operator<<(std::ostream&, const Account&);
  private:
  static constexpr double def_acc_balance = 0.0;
  protected:
    static constexpr const char *def_acc_name = "No name";
    double balance;
    std::string name;
  public:
    Account(std::string name = def_acc_name, double balance = def_acc_balance);
    ~Account();
    double get_balance();
    bool deposit(double);
    bool withdraw(double);
};

#endif