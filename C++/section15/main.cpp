#include <iostream>
#include <vector>
#include "Account.h"
#include "Checking_Account.h"
#include "Trust_Account.h"
using namespace std;

int main(void) {
  cout.precision(2);
  cout << fixed;

  vector<Account> accounts;
  
  accounts.push_back(Account());
  accounts.push_back(Account("Rafael", 1000));
  accounts.push_back(Account("Pedro", 300));
  accounts.push_back(Account("Guilherme", 200));
  accounts.push_back(Account("Felipe", 100));

  cout << endl;

  for (auto &acc : accounts) {
    cout << "Sacando R$300 de " << acc << " " << (acc.withdraw(300) ? "OK" : "ERROR") << endl;
  }

  cout << endl;

  for (auto &acc : accounts) {
    cout << "Depositando R$100 de " << acc << " " << (acc.deposit(100) ? "OK" : "ERROR") << endl;
  }

  cout << endl;

  for (auto &acc : accounts) {
    cout << "Depositando R$-100 de " << acc << " " << (acc.deposit(-100) ? "OK" : "ERROR") << endl;
  }

  cout << endl;

  for (const auto &acc : accounts) {
    cout << acc << endl;
  }

  cout << endl;

  vector<Checking_Account> check_accounts;
  check_accounts.push_back(Checking_Account());
  check_accounts.push_back(Checking_Account("Odisseu", 3000));
  check_accounts.push_back(Checking_Account("Ulisses"));
  check_accounts.push_back(Checking_Account("Paris", 500));
  check_accounts.push_back(Checking_Account("Menelau", 100));

  for (auto &acc : check_accounts) {
    cout << "Depositando R$1000 de " << acc << " " << (acc.deposit(1000) ? "OK" : "ERROR") << endl;
  }

  cout << endl;

  for (auto &acc : check_accounts) {
    cout << "Sacando R$1500 de " << acc << " " << (acc.withdraw(1500) ? "OK" : "ERROR") << endl;
  }

  cout << endl;

  for (const auto &acc : check_accounts) {
    cout << acc << endl;
  }

  vector<Trust_Account> trust_accounts;
  trust_accounts.push_back(Trust_Account());
  trust_accounts.push_back(Trust_Account("Belami", 3000));
  trust_accounts.push_back(Trust_Account("Clark"));
  trust_accounts.push_back(Trust_Account("William", 500));

  cout << endl;

  cout << "Depositando R$5000 de " << trust_accounts.at(0) << " " << (trust_accounts.at(0).deposit(5000) ? "OK" : "ERROR") << endl;
  cout << "Depositando R$1000 de " << trust_accounts.at(1) << " " << (trust_accounts.at(1).deposit(1000) ? "OK" : "ERROR") << endl;

  cout << endl;

  for (auto &acc : trust_accounts) {
    cout << "Sacando R$100 de " << acc << " " << (acc.withdraw(100) ? "OK" : "ERROR") << endl;
  }

  cout << endl;

  for (auto &acc : trust_accounts) {
    cout << "Sacando R$100 de " << acc << " " << (acc.withdraw(100) ? "OK" : "ERROR") << endl;
  }

  cout << endl;

  for (auto &acc : trust_accounts) {
    cout << "Sacando R$100 de " << acc << " " << (acc.withdraw(100) ? "OK" : "ERROR") << endl;
  }

  cout << endl;

  for (auto &acc : trust_accounts) {
    cout << "Sacando R$100 de " << acc << " " << (acc.withdraw(100) ? "OK" : "ERROR") << endl;
  }

  cout << endl;

  for (const auto &acc : trust_accounts) {
    cout << acc << endl;
  }

  cout << endl;

  return 0;
}