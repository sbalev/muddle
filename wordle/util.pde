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
