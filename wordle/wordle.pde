import java.util.*;

// set this to true when building your trees and to false when playing
static boolean evalBonus = false;

StringList dictionary;
Bot bot;

void setup() {
  size(400, 400);
  dictionary = new StringList(loadStrings("words.txt"));
  StringList solutions = new StringList(loadStrings("solutions.txt"));
  
  // Uncomment this to create and save a tree
  // Node root = createTree(solutions, Strategy.ENTROPY, 10);
  // saveTree(root, "data/rootENTROPY10.json");
  
  Node root = loadTree("rootENTROPY10.json", solutions);
  root.printInfo();
  
  bot = new Bot(root.children[0].children[0]);
  println(bot.possibleClues);
  bot.display();
}

void draw() {
}

void keyPressed() {
  bot.keyPressed();
  bot.display();
}
