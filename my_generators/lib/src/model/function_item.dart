import 'package:analyzer/dart/ast/ast.dart';
import 'package:my_generators/src/model/file_content.dart';
import 'package:my_generators/src/model/selector.dart';
import 'package:my_generators/src/utils/extensions.dart';

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

  BlockFunctionBody? getBlockFuncBodyFromBlock(Block block) {
    return block.parent?.parent?.childEntities
        .whereType<BlockFunctionBody>()
        .firstOrNull;
  }

  // 2 because when no parameter, we still have begin and OPEN_PAREN and CLOSE_PAREN (BeginToken and EndToken)
  bool get hasNoParam => this.paramList.childEntities.length <= 2;
  bool isAsync() {
    final blockFunc = getBlockFuncBodyFromBlock(block);
    if (blockFunc == null) return false;
    return blockFunc.isAsynchronous;
  }

  toString([ArgumentList? argumentList = null]) {
    try {
      return toStringCalledWith(argumentList);
    } catch (e) {
      return "RANGE ERROR";
    }
  }

  toStringCalledWith([ArgumentList? argumentList = null]) {
    StringBuffer stringBuffer = StringBuffer();

    final functionBody = file.resolveContent(selector);
    stringBuffer
        .writeln(" // " + camelToSentence(methodName) + ' $methodName()');
    final _isAwaitedAsync = isAwaitedAsync(argumentList);

    if ((hasNoParam && !isAsync()) ||
        hasNoParam && isAsync() && _isAwaitedAsync) {
      stringBuffer.writeln(functionBody);
      stringBuffer.writeln();
      return stringBuffer.toString();
    }

    if (isAsync()) {
      stringBuffer.write(" await ");
    }
    stringBuffer.write(paramList.toSource());
    if (isAsync()) {
      stringBuffer.write(" async ");
    }
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

  bool isAwaitedAsync(ArgumentList? argumentList) {
    return (argumentList?.parent?.parent is AwaitExpression);
    // grandpa because pa  of ArgumentList is MethodInvocation
  }
}
