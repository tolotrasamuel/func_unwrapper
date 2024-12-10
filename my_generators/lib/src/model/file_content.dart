import 'package:my_generators/src/model/selector.dart';

class FileContent {
  final List<String> imports;
  final String fileName;
  String content;
  int offset;

  FileContent(this.content, this.offset, this.fileName, this.imports);

  void replaceAt({required Selector pasteAt, required String replacement}) {
    content = content.replaceRange(
      pasteAt.from,
      pasteAt.to,
      replacement,
    );
    var offsetChange = replacement.length - pasteAt.length;
    offset += offsetChange;
    content;
  }

  String resolveContent(Selector selector) {
    return content.substring(selector.from, selector.to);
  }
}
