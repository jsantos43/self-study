#include <iostream>
#include <string>
using namespace std;

int main(void) {
  string alphabet{"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSYUVWXYZ"};
  string key{"FGHIJKLMNOPQRSYUVWXYZABCDEfghijklmnopqrstuvwxyzabcde"};


  string message;

  cout << "Enter your message to encrypt: ";
  getline(cin, message);

  string encrypt;
  string decrypt;

  int key_index{};
  for (char letter: message) {
    if (isalpha(letter)) {
      key_index = alphabet.find(letter);
      encrypt += key.at(key_index);
    } else {
      encrypt += letter;
    }
  }

  int alphabet_index{};
  for (char letter: encrypt) {
    if (isalpha(letter)) {
      alphabet_index = key.find(letter);
      decrypt += alphabet.at(alphabet_index);
    } else {
      decrypt += letter;
    }
  }

  cout << "\n\n";
  cout << "Your message encrypted is: " << encrypt << endl;
  cout << "Your message decrypted is: " << decrypt << endl;

  return 0;
}