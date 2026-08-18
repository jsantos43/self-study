#include "Movies.h"

// Defining vector
std::vector<Movies> Movies::vec;

// Constructor
Movies::Movies(std::string n, int r, int t){
  name = n;
  rating = r;
  timesplayed = t;
}

// Copy
Movies::Movies(const Movies &source)
  : name {source.name}, rating {source.rating}, timesplayed {source.timesplayed} {
}

// Move
Movies::Movies(Movies &&source)
  : name {std::move(source.name)}, rating {source.rating}, timesplayed {source.timesplayed} {
}

// Destructor
Movies::~Movies() {
  std::cout << "Destructor: " << this->name << std::endl;
}

bool Movies::search_movie(std::string n) {
  for (const auto &movie: Movies::vec) {
    if (movie.name == n) return true;
  }

  return false;
}

void Movies::add(){
  std::string n;
  int r {};
  int t {};

  std::cout << "Enter a name of a movie: ";
  std::cin >> n;

  if (Movies::search_movie(n)) {
    std::cout << "ERROR: movie already registered!" << std::endl;
    return;
  }

  std::cout << "Enter the rating: ";
  std::cin >> r;

  std::cout << "Enter the times you have watched: ";
  std::cin >> t;

  Movies::vec.push_back(Movies(n, r, t));
}

void Movies::display_all() {
  for (const auto &movie: Movies::vec) {
    std::cout << "\n===================\n";
    std::cout << "Name: " << movie.name << std::endl;
    std::cout << "Rating: " << movie.rating << std::endl;
    std::cout << "Times Played: " << movie.timesplayed << std::endl;
    std::cout << "\n===================\n";
  }
}

void Movies::increment_time(std::string n) {
  bool found { false };

  for (auto &movie: Movies::vec) {
    if (movie.name == n) {
      found = true;
      movie.timesplayed++;
    } 
  }

  if (!found) {
    std::cout << "ERROR: Movie not found!" << std::endl;
  }
}
