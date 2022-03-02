import java.util.*;

// set this to true when building your trees and to false when playing
static boolean evalBonus = true;

StringList dictionary;

void setup() {
  dictionary = new StringList(loadStrings("words.txt"));
  StringList solutions = new StringList(loadStrings("solutions.txt"));
  
  /*int opt = 10;
  for (Strategy strat : Strategy.values()) {
    println(strat);
    Node root = createTree(solutions, strat, opt);
    root.printInfo();
    saveTree(root, "data/root" + strat + opt + ".json");
  }*/
  
  Node root = loadTree("rootENTROPY10.json", solutions);
  root.printInfo();
  int[] clues = {14, 41};
  for (int clue : clues) {
    root = root.children[clue];
    println(root.guess);
  }
  println(root.solutions);
}
