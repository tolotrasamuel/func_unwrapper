import 'package:my_generators/src/model/selector.dart';

class FileContent {
  final String fileName;
  String content;
  int offset;

  FileContent(this.content, this.offset, this.fileName);

  void replaceAt({required Selector pasteAt, required String replacement}) {
    this.content = this.content.replaceRange(
        pasteAt.from + this.offset, pasteAt.to + this.offset, replacement);
    var offsetChange = replacement.length - pasteAt.length;
    this.offset += offsetChange;
    this.content;
  }
}
