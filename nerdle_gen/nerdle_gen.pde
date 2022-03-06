StringList solutions = new StringList();

void setup() {
  char[] ops = {'+', '-', '*', '/'};
  // a op b = c
  for (int a = 1; a <= 999; a++) {
    for (int b = 1; b <= 999; b++) {
      for (char op : ops) {
        addExprIfValid(a, op, b, solutions);
      }
    }
  }
  println(solutions.size());

  // a op b op c
  for (int a = 1; a <= 99; a++) {
    for (int b = 1; b <= 99; b++) {
      for (int c = 1; c <= 99; c++) {
        for (char op1 : ops) {
          for (char op2 : ops) {
            addExprIfValid(a, op1, b, op2, c, solutions);
          }
        }
      }
    }
  }

  println(solutions.size());
  //saveStrings("words.txt", solutions.array());
  
  //println(equalsPos());
}

int eval(int a, char op, int b) {
  switch (op) {
  case '+' :
    return a + b;
  case '-' :
    return a - b;
  case '*' :
    return a * b;
  case '/' :
    return a / b;
  }
  return -1;
}

void addExprIfValid(int a, char op, int b, StringList list) {
  if ((op == '-' && a < b) || (op == '/' && a % b != 0)) return;
  String s = "" + a + op + b + "=" + eval(a, op, b);
  if (s.length() == 8) list.append(s);
}

void addExprIfValid(int a, char op1, int b, char op2, int c, StringList list) {
  int v;
  if ((op2 == '*' || op2 == '/') && (op1 == '+' || op1 == '-')) {
    if (op2 == '/' && b % c != 0) return;
    v = eval(a, op1, eval(b, op2, c));
  } else {
    if (op1 == '/' && a % b != 0) return;
    v = eval(a, op1, b);
    if (op2 == '/' && v % c != 0) return;
    v = eval(v, op2, c);
  }
  if (v < 0) return;
  String s = "" + a + op1 + b + op2 + c + "=" + v;
  if (s.length() == 8) list.append(s);
}
