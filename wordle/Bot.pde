class Bot {
  Node root, currentNode;
  IntList path;
  IntList possibleClues;
  int currentClue;
  int pos;
  PFont smallFont, bigFont;

  Bot(Node root) {
    this.root = currentNode = root;
    path = new IntList();
    possibleClues = new IntList();
    initClues();
    pos = 0;
    smallFont = createFont("DejaVu Sans Mono", CELL_SIZE / 2);
    bigFont = createFont("DejaVu Sans Mono", CELL_SIZE);
  }

  void initClues() {
    possibleClues.clear();
    if (currentNode.children != null) {
      for (int clue = 0; clue < CLUE_COUNT - 1; clue++) {
        if (currentNode.children[clue] != null) possibleClues.append(clue);
      }
    }
    if (currentNode.solutions.hasValue(currentNode.guess)) {
      possibleClues.append(CLUE_COUNT - 1);
    }
    currentClue = possibleClues.get(0);
  }

  void changeCurrentClue(boolean down) {
    int nextClue = -1;
    int minDigit = down ? digit(currentClue, pos) : -1;
    int maxDigit = down ? 3 : digit(currentClue, pos);
    for (int clue : possibleClues) {
      if (samePrefix(clue, currentClue, pos)) {
        int d = digit(clue, pos);
        if (minDigit < d && d < maxDigit) {
          nextClue = clue;
          if (down) {
            maxDigit = d;
          } else {
            minDigit = d;
          }
        }
      }
    }
    if (nextClue != -1) currentClue = nextClue;
  }
  
  void changeCurrentNode() {
    if (currentClue == CLUE_COUNT - 1) return;
    path.append(currentClue);
    currentNode = currentNode.children[currentClue];
    initClues();
    pos = 0;
  }

  void display() {
    background(255);
    
    // path from root
    int x = PADDING, y = x;
    Node node = root;
    for (int clue : path) {
      displayNode(node, clue, x, y);
      node = node.children[clue];
      y += CELL_SIZE + PADDING;
    }
    displayNode(currentNode, currentClue, x, y);
    
    // position pointer
    y += CELL_SIZE;
    noStroke();
    fill(0);
    int xPos = x + pos * (CELL_SIZE + PADDING) + CELL_SIZE / 2;
    triangle(xPos, y, xPos - CELL_SIZE / 6, y + CELL_SIZE / 4,
      xPos + CELL_SIZE / 6, y + CELL_SIZE / 4);
    
    // words left
    y += CELL_SIZE / 2;
    textFont(smallFont);
    textAlign(LEFT, TOP);
    fill(0);
    if (currentClue == CLUE_COUNT - 1) {
      text("Good job", x, y);
      return;
    }
    Node nextNode = currentNode.children[currentClue];
    int n = nextNode.solutions.size();
    String s = n + " possible word" + (n == 1 ? "" : "s") + "("
      + nf(log(n) / log(2), 0, 2) + ")"; 
    text(s, x, y);
    y += CELL_SIZE;
    int y0 = y;
    for (String solution : nextNode.solutions) {
      text(solution, x,y);
      y += CELL_SIZE / 2;
      if (y + CELL_SIZE / 2 >= height) {
        y = y0;
        x += (WORD_LENGTH + 1) * textWidth("w");
      }
    }
  }
  
  void displayNode(Node node, int clue, int x, int y) {
    noStroke();
    rectMode(CORNER);
    textFont(bigFont);
    textAlign(CENTER, CENTER);
    for (int i = 0; i < WORD_LENGTH; i++) {
      fill(CLUE_COLORS[clue % 3]);
      clue /= 3;
      square(x + i * (CELL_SIZE + PADDING), y, CELL_SIZE);
      fill(TEXT_COLOR);
      String letter = node.guess.substring(i, i + 1).toUpperCase(); 
      text(letter, x + i * (CELL_SIZE + PADDING) + CELL_SIZE / 2, y + CELL_SIZE / 2.5);
    }
    // entropy info
    float toDiscover = log(node.solutions.size()) / log(2);
    float expected = -Strategy.ENTROPY.eval(node.guess, node.solutions);
    float left = toDiscover - expected;
    String s = String.format("%.2f-%.2f=%.2f",toDiscover, expected, left);
    fill(0);
    textFont(smallFont);
    textAlign(LEFT, CENTER);
    text(s, x + WORD_LENGTH * (CELL_SIZE + PADDING), y + CELL_SIZE / 2.5);    
  }

  void keyPressed() {
    if (key == ENTER || key == RETURN) {
      changeCurrentNode();
    } else if (key == CODED) {
      switch (keyCode) {
      case UP:
        changeCurrentClue(false);
        break;
      case DOWN:
        changeCurrentClue(true);
        break;
      case LEFT:
        pos = constrain(pos - 1, 0, WORD_LENGTH - 1);
        break;
      case RIGHT:
        pos = constrain(pos + 1, 0, WORD_LENGTH - 1);
        break;
      }
    }
  }
}
