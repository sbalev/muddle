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

// run this with size(1050, 375)
void drawCorrelations(StringList solutions) {
  background(255);
  float x0 = 25;
  drawCorrelation(solutions, Strategy.MAX_SIZE, Strategy.AVG_SIZE, x0, 50, 300);
  x0 += 350;
  drawCorrelation(solutions, Strategy.MAX_SIZE, Strategy.ENTROPY, x0, 50, 300);  
  x0 += 350;
  drawCorrelation(solutions, Strategy.AVG_SIZE, Strategy.ENTROPY, x0, 50, 300);  
}

void drawCorrelation(StringList solutions, Strategy sx, Strategy sy, float x0, float y0, float size) {
  stroke(0);
  noFill();
  rectMode(CORNER);
  square(x0, y0, size);
  String title = sx + "/" + sy;
  textSize(16);
  textAlign(CENTER, BOTTOM);
  fill(0);
  text(title, x0 + size / 2, y0 - 10);
  FloatDict ranksX = sx.guessRanks(dictionary, solutions);
  float xMin = ranksX.value(0);
  float xMax = ranksX.value(ranksX.size() - 1);
  FloatDict ranksY = sy.guessRanks(dictionary, solutions);
  float yMin = ranksY.value(0);
  float yMax = ranksY.value(ranksY.size() - 1);
  noStroke();
  fill(0, 126, 198, 16);
  for (String guess : dictionary) {
    float x = map(ranksX.get(guess), xMin, xMax, x0, x0 + size);
    float y = map(ranksY.get(guess), yMin, yMax, y0 + size, y0);
    circle(x, y, 5);
  }
}
