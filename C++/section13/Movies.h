#ifndef MOVIES_H
#define MOVIES_H

#include <iostream>
#include <string>
#include <vector>

class Movies {
  private:
    std::string name;
    int rating;
    int timesplayed;
    static std::vector<Movies> vec;
  public:
    Movies(std::string, int, int); // Constructor
    Movies(const Movies &source); // Copy
    Movies(Movies &&source); // Move
    ~Movies(); // Destructor
    static bool search_movie(std::string);
    static void add();
    static void display_all();
    static void increment_time(std::string);
};

#endif