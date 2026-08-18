#include <iostream>
#include "Movies.h"
using namespace std;

int main(void) {
  Movies::add();
  Movies::display_all();

  Movies::add();
  Movies::increment_time("Odyssey");
  Movies::increment_time("Odyssey");

  Movies::display_all();

  return 0;
}