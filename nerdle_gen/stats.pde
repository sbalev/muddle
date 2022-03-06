JSONArray frequencies() {
  String chars = "0123456789+-*/=";
  int[] count = new int[chars.length()];
  for (String solution : solutions) {
    for (char c : solution.toCharArray()) {
      count[chars.indexOf(c)]++;
    }
  }
  JSONArray freqs = new JSONArray();
  for (int i = 0; i < count.length; i++) {
    JSONObject entry = new JSONObject();
    entry.setString("digit", chars.substring(i, i + 1));
    entry.setFloat("frequency", count[i] / (8.0 * solutions.size()));
    freqs.append(entry);
  }
  return freqs;
}

float[] equalsPos() {
  float[] pos = new float[8];
  for(String solution : solutions) {
    pos[solution.indexOf('=')]++;
  }
  for (int i = 0; i < 8; i++) {
    pos[i] /= solutions.size();
  }
  return pos;
}
