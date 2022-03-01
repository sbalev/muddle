import java.util.*;

// set this to true when building your trees and to false when playing
static boolean evalBonus = false;

StringList dictionary;

void setup() {
  dictionary = new StringList(loadStrings("words.txt"));
  StringList solutions = new StringList(loadStrings("solutions.txt"));
  
  printTop(10, solutions);
}
