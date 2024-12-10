class Selector {
  // included
  int from;
  // included
  int to;

  Selector(this.from, this.to);

  int get length => to - from;
  void addOffset(int offsetChange) {
    from += offsetChange;
    to += offsetChange;
  }
}
