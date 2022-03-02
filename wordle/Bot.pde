class Bot {
  Node root, current;
  IntList path;
  IntList possibleClues;
  int currentClue;
  int pos;

  Bot(Node root) {
    this.root = current = root;
    path = new IntList();
    possibleClues = new IntList();
    initClues();
    pos = 0;
  }

  void initClues() {
    possibleClues.clear();
    if (current.children != null) {
      for (int clue = 0; clue < CLUE_COUNT - 1; clue++) {
        if (current.children[clue] != null) possibleClues.append(clue);
      }
    }
    if (current.solutions.hasValue(current.guess)) {
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

  void display() {
    background(255);
    noStroke();
    int c = currentClue;
    for (int i = 0; i < WORD_LENGTH; i++) {
      fill(BACKGROUND_COLORS[c % 3]);
      square(10 + i * 60, 10, 50);
      c /= 3;
    }
    int tx = 10 + pos * 60 + 25;
    int ty = 60;
    fill(0);
    triangle(tx, ty, tx - 10, ty + 20, tx + 10, ty + 20);
  }

  void keyPressed() {
    if (key == CODED) {
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
        pos = constrain(pos + 1, 0, WORD_LENGTH + 1);
        break;
      }
    }
  }
}
