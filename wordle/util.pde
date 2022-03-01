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
