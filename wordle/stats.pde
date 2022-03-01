void printTop(int n, StringList solutions) {
  Map<Strategy,FloatDict> ranks = new HashMap();
  for (Strategy s : Strategy.values()) {
    ranks.put(s, s.guessRanks(dictionary, solutions));
  }
  for (int i = 0; i < n; i++) {
    String line = "|" + i + "|";
    for (Strategy s : Strategy.values()) {
      FloatDict rank = ranks.get(s);
      line += rank.key(i) + "|" + s.evalToString(rank.value(i)) + "|";
    }
    println(line);
  }
}
