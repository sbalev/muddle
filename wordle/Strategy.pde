enum Strategy {
  MAX_SIZE {
    float evalHelper(int n) {
      return max(distribution);
    }
    
    String evalToString(float eval) {
      return "" + int(eval);
    }
  },
  AVG_SIZE {
    float evalHelper(int n) {
      float sum = 0;
      for (int d : distribution) sum += d * d;
      return sum / n;
    }
    
    String evalToString(float eval) {
      return nf(eval, 0, 3);
    }
  },
  ENTROPY {
    float evalHelper(int n) {
      float e = 0;
      for (int ni : distribution) {
        if (ni > 0) {
          e -= ni * log(ni);
        }
      }
      return -(e / n + log(n)) / log(2);
    }
    
    String evalToString(float eval) {
      return nf(-eval, 0, 3);
    }
  };

  final float EPS = 1.0e-4;
  int[] distribution = new int[CLUE_COUNT];

  void computeDistribution(String guess, StringList solutions) {
    Arrays.fill(distribution, 0);
    for (String solution : solutions) distribution[clue(guess, solution)]++;
  }

  float eval(String guess, StringList solutions) {
    computeDistribution(guess, solutions);
    float e = evalHelper(solutions.size());
    if (evalBonus && distribution[CLUE_COUNT - 1] > 0) e -= EPS;
    return e;
  }
  
  FloatDict guessRanks(StringList guesses, StringList solutions) {
    FloatDict ranks = new FloatDict(guesses.size());
    for (String guess : guesses) ranks.set(guess, eval(guess, solutions));
    ranks.sortValues();
    return ranks;
  }
  
  String bestGuess(StringList guesses, StringList solutions) {
    String bestGuess = null;
    float bestScore = Float.POSITIVE_INFINITY;
    for (String guess : guesses) {
      float score = eval(guess, solutions);
      if (score < bestScore) {
        bestScore = score;
        bestGuess = guess;
      }
    }
    return bestGuess;
  }

  abstract float evalHelper(int n);
  abstract String evalToString(float eval);
}
