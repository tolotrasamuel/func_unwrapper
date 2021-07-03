extension MyIterable<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;

  T? firstWhereOrNull(bool Function(T element) test) {
    final list = where(test);
    return list.isEmpty ? null : list.first;
  }
}

String camelToSentence(String text) {
  return text.replaceAllMapped(RegExp(r'^([a-z])|[A-Z]'), (Match m) {
    var m1 = m[1];
    if (m1 == null) {
      return " ${m[0]}";
    }
    return m1.toUpperCase();
  });
}

String upperCamelToLowerCal(String text) {
  return text[0].toLowerCase() + text.substring(1);
}
