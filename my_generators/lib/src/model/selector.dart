class Selector {
  // included
  int from;
  // included
  int to;

  Selector(this.from, this.to);

  int get length => this.to - this.from;
  void addOffset(int offsetChange) {
    this.from += offsetChange;
    this.to += offsetChange;
  }
}
