import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';
import 'package:my_generators/src/model/file_content.dart';
import 'package:my_generators/src/model/selector.dart';

class FunctionItem {
  final FileContent file;
  final String methodName;
  final AstNode astNode;
  final Selector selector;
  bool unwrapped;

  FunctionItem({
    required this.file,
    required this.methodName,
    required this.astNode,
    required this.unwrapped,
    required this.selector,
  });

  toString() {
    return this.file.content.substring(selector.from, selector.to);
  }

  static Selector getBlockSelector(Block withElementWithOriginalOffset) {
    final statements = withElementWithOriginalOffset.childEntities
        .where((e) => (e is AstNode));
    if (statements.isEmpty) return Selector(0, 0);
    return Selector(statements.first.offset, statements.last.end);
  }
}
