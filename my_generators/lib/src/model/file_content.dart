import 'package:my_generators/src/model/selector.dart';

class FileContent {
  final String fileName;
  String content;
  int offset;

  FileContent(this.content, this.offset, this.fileName);

  void replaceAt({required Selector pasteAt, required String replacement}) {
    this.content = this.content.replaceRange(
          pasteAt.from,
          pasteAt.to,
          replacement,
        );
    var offsetChange = replacement.length - pasteAt.length;
    this.offset += offsetChange;
    this.content;
  }

  String resolveContent(Selector selector) {
    return content.substring(selector.from, selector.to);
  }
}
