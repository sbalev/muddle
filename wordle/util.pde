static int clue(String guess, String solution) {
  int score = 0, used = 0, power3 = 1;
  for (int i = 0; i < WORD_LENGTH; i++) {
    if (guess.charAt(i) == solution.charAt(i)) {
      used |= 1 << i;
      score += 2 * power3;
    }
    power3 *= 3;
  }
  power3 = 1;
  for (int i = 0; i < WORD_LENGTH; i++) {
    if (guess.charAt(i) != solution.charAt(i)) {
      for (int j = 0; j < WORD_LENGTH; j++) {
        if ((used & (1 << j)) == 0 && guess.charAt(i) == solution.charAt(j)) {
          used |= 1 << j;
          score += power3;
          break;
        }
      }
    }
    power3 *= 3;
  }
  return score;
}

boolean samePrefix(int clue1, int clue2, int pos) {
  for (int i = 0; i < pos; i++) {
    if (clue1 % 3 != clue2 % 3) return false;
    clue1 /= 3;
    clue2 /= 3;
  }
  return true;
}

int digit(int clue, int pos) {
  for (int i = 0; i < pos; i++) clue /= 3;
  return clue % 3;
}


static StringList[] splitSolutions(String guess, StringList solutions) {
  StringList[] split = new StringList[CLUE_COUNT];
  for (String solution : solutions) {
    int j = clue(guess, solution);
    if (split[j] == null) split[j] = new StringList();
    split[j].append(solution);
  }
  return split;
}

Node createTree(StringList solutions, Strategy strat, int opt) {
  println("Building tree ...");
  int start = millis();
  Node root = new Node(solutions, strat);
  if (opt > 1) root.optimizeGuess(opt, strat);
  int time = millis() - start;
  println("Done in", nf(time/1000.0, 0, 2), "s");
  return root;
}

void saveTree(Node root, String fileName) {
  saveJSONObject(root.toJSON(), fileName, "compact");
}

Node loadTree(String fileName, StringList solutions) {
  JSONObject jRoot = loadJSONObject(fileName);
  return new Node(jRoot, solutions);
}
