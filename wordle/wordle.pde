import java.util.*;

// set this to true when building your trees and to false when playing
static boolean evalBonus = false;

StringList dictionary;

void setup() {
  size(1050, 375);
  
  dictionary = new StringList(loadStrings("words.txt"));
  StringList solutions = new StringList(loadStrings("solutions.txt"));
  
  drawCorrelations(solutions);
}
