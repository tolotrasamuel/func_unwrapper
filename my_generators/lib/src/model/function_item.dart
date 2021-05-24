import 'package:analyzer/dart/ast/ast.dart';
import 'package:my_generators/src/model/file_content.dart';
import 'package:my_generators/src/model/selector.dart';

String camelToSentence(String text) {
  return text.replaceAllMapped(RegExp(r'^([a-z])|[A-Z]'), (Match m) {
    var m1 = m[1];
    if (m1 == null) {
      return " ${m[0]}";
    }
    return m1.toUpperCase();
  });
}

class FunctionItem {
  final FileContent file;
  final String methodName;
  final Block block;
  final FormalParameterList paramList;
  final Selector selector;
  bool unwrapped;

  FunctionItem({
    required this.file,
    required this.methodName,
    required this.paramList,
    required this.block,
    required this.unwrapped,
    required this.selector,
  });

  toString([ArgumentList? argumentList = null]) {
    return toStringCalledWith(argumentList);
  }

  toStringCalledWith([ArgumentList? argumentList = null]) {
    StringBuffer stringBuffer = StringBuffer();

    final functionBody = file.resolveContent(selector);
    // 2 because when no parameter, we still have begin and OPEN_PAREN and CLOSE_PAREN (BeginToken and EndToken)

    stringBuffer
        .writeln(" // " + camelToSentence(methodName) + ' $methodName()');
    if (this.paramList.childEntities.length <= 2) {
      stringBuffer.writeln(functionBody);
      stringBuffer.writeln();
      return stringBuffer.toString();
    }
    stringBuffer.write(paramList.toSource());
    stringBuffer.writeln("{");
    stringBuffer.writeln(functionBody);
    stringBuffer.write("}");

    if (argumentList == null) {
      // This case handles a scenario where parameters are all optionals and no argument were sent
      // print('Argument list is null alghough function'
      //     ' declaration seems to have params');
      // we just return this instead of throwing for debugging purposes (toString is used in debug console by default)
      stringBuffer.write("()");
    } else {
      stringBuffer.write(argumentList.toSource());
    }
    stringBuffer.write(";");
    stringBuffer.writeln();
    return stringBuffer.toString();
  }

  static Selector getBlockSelector(Block withElementWithOriginalOffset) {
    final statements = withElementWithOriginalOffset.childEntities
        .where((e) => (e is AstNode));
    if (statements.isEmpty) return Selector(0, 0);
    return Selector(statements.first.offset, statements.last.end);
  }
}
