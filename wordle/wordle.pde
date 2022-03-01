import java.util.*;

// set this to true when building your trees and to false when playing
static boolean evalBonus = true;

StringList dictionary;

void setup() {
  dictionary = new StringList(loadStrings("words.txt"));
  StringList solutions = new StringList(loadStrings("solutions.txt"));
  
  Node root = new Node(solutions, Strategy.ENTROPY);
  //root.printInfo();
  println(root.guess);

  int[] clues = {36, 61};
  for (int clue : clues) {
    root = root.children[clue];
    println(root.guess);
  }
  println(root.solutions);
}
