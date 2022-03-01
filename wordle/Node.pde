class Node {
  String guess;
  StringList solutions;
  Node[] children;
  
  Node(StringList solutions, Strategy strat) {
    this.solutions = solutions;
    if (solutions.size() == 1) {
      guess = solutions.get(0);
      return;
    }
    children = new Node[CLUE_COUNT - 1];
    init(strat.bestGuess(dictionary, solutions), strat);
  }
  
  void init(String guess, Strategy strat) {
    this.guess = guess;
    StringList[] split = splitSolutions(guess, solutions);
    for (int j = 0; j < CLUE_COUNT - 1; j++) {
      children[j] = split[j] == null ? null : new Node(split[j], strat);
    }
  }
  
  void optimizeGuess(int attempts, Strategy strat) {
    if (solutions.size() == 1) return;
    String bestGuess = guess;
    float bestScore = averageScore();
    FloatDict ranks = strat.guessRanks(dictionary, solutions);
    for (int i = 1; i < attempts; i++) {
      init(ranks.key(i), strat);
      float score = averageScore();
      if (score < bestScore) {
        bestScore = score;
        bestGuess = guess;
      }
    }
    init(bestGuess, strat);
    for (Node child : children) {
      if (child != null) child.optimizeGuess(attempts, strat);
    }
  }

  
  int score(String solution) {
    int clue = clue(guess, solution);
    return 1 + (clue == CLUE_COUNT - 1 ? 0 : children[clue].score(solution));
  }

  int totalScore() {
    int total = 0;
    for (String solution : solutions) total += score(solution);
    return total;
  }
  
  float averageScore() {
    return totalScore() / float(solutions.size());
  }

  int depth() {
    if (solutions.size() == 1) return 1;
    int dMax = 0;
    for (Node child : children) {
      if (child != null) dMax = max(dMax, child.depth());
    }
    return 1 + dMax;
  }

  int[] scoreDistribution() {
    int[] distrib = new int[depth() + 1];
    for (String solution : solutions) distrib[score(solution)]++;
    return distrib;
  }
  
  void printInfo() {
    println(guess, solutions.size(), totalScore(), nf(averageScore(), 0, 4));
    println(scoreDistribution());
  }
}
