import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:my_generators/src/model/file_content.dart';
import 'package:my_generators/src/model/function_item.dart';
import 'package:my_generators/src/model/selector.dart';
import 'package:source_gen/source_gen.dart';

class LibraryResolver {
  FileContent? fileContent;
  final String path;

  LibraryResolver(this.path);
}

class FunctionUnwrap extends Generator {
  final List<FunctionItem> items = [];
  // FileContent fileContent;
  // List<LibraryResolver> libResolvers = [];
  late BuildStep buildStep;
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    items.clear();
    this.buildStep = buildStep;
    final inputId = buildStep.inputId;
    final ans = await resolveLib(library.element, inputId);
    return ans;
  }

  Future<String> resolveLib(LibraryElement element, AssetId inputId) async {
    final externalLib = element.importedLibraries
        .where((element) => element.identifier.endsWith(".source.util.dart"));
    if (externalLib.isNotEmpty) {
      for (var libElment in externalLib) {
        final assetId = await buildStep.resolver.assetIdForElement(libElment);
        await resolveLib(libElment, assetId);
      }
    }
    // libResolvers.add(LibraryResolver(element.identifier));

    String content = await buildStep.readAsString(inputId);
    FileContent fileContent = FileContent(content, 0, element.identifier);
    LibraryReader library = LibraryReader(element);

    for (var element in library.allElements) {
      print("${element.runtimeType} runtimeType ${element.toString()}}");
      var astNode = await buildStep.resolver.astNodeFor(element, resolve: true);
      if (astNode != null) {
        buildFunctions(astNode, fileContent);
      }
    }

    var i = 0;
    for (var element in library.allElements) {
      var astNode = await buildStep.resolver.astNodeFor(element, resolve: true);
      print("${element.runtimeType} ${i++} runtimeType ${element.toString()}}");
      if (astNode != null) {
        resolveFunction(astNode, fileContent);
      }
    }

    return fileContent.content;
  }

  void resolveFunction(AstNode nodeChild, FileContent fileContent) {
    recurse(nodeChild, (AstNode node) {
      try {
        var methodInvocation = node as MethodInvocation;
        final funcName = methodInvocation.childEntities
            .whereType<SimpleIdentifier>()
            .first
            .name;
        if (funcName == "testDogWoof") {
          print("here");
        }
        final existing = this.getFunctionItemByMethodName(funcName);
        if (existing.isNotEmpty) {
          if (existing.first.unwrapped != true) {
            resolveFunction(existing.first.astNode, fileContent);
            existing.first.unwrapped = true;
          }
          // parent because we need to take into account the trailing semicolumn;
          final nodeTarget = node.parent!;

          final copySelector = existing.first.selector;
          final pasteSelector = Selector(nodeTarget.offset, nodeTarget.end);
          fileContent.replaceAt(
            pasteAt: pasteSelector,
            replacement: existing.first.toString(),
          );
          this.updateAllSelectors(
              pasteSelector: pasteSelector,
              changedLengthTo: copySelector.length);
          print(items.length);
        }
      } catch (e) {
        e.hashCode;
      }
    });
  }

  void recurse(AstNode astNode, Function(AstNode node) callback) {
    for (var child in astNode.childEntities) {
      if (child is AstNode) {
        final nodeChild = child as AstNode;
        callback(nodeChild);
        recurse(nodeChild, callback);
      }
    }
    // if the node visited is a function, it must have been unwrapped
    // by the end of the recursion
    if (astNode is FunctionDeclaration) {
      final funcName = getFuncNameFromFuncDeclaration(astNode);
      final existing = getFunctionItemByMethodName(funcName);
      if (existing.isNotEmpty) {
        existing.first.unwrapped = true;
      }
    }
  }

  void buildFunctions(AstNode astNode, FileContent fileContent) {
    if (astNode == null) {
      return;
    }
    try {
      var functionDeclaration = astNode as FunctionDeclaration;
      var metadata = functionDeclaration.metadata.whereType<Annotation>().first;
      if ((metadata.childEntities.toList()[1] as SimpleIdentifier).name ==
          "UnWrap") {
        final block = getFuncBodyFromFuncDeclaration(functionDeclaration);
        items.add(FunctionItem(
            file: fileContent,
            methodName: getFuncNameFromFuncDeclaration(functionDeclaration),
            astNode: block,
            unwrapped: false,
            selector: FunctionItem.getBlockSelector(block)));
      }
    } catch (e) {}
  }

  String getFuncNameFromFuncDeclaration(FunctionDeclaration astNode) {
    return astNode.childEntities.whereType<SimpleIdentifier>().first.name;
  }

  Block getFuncBodyFromFuncDeclaration(FunctionDeclaration astNode) {
    final funcExpression =
        astNode.childEntities.whereType<FunctionExpression>().first;
    final blockFuncBody =
        funcExpression.childEntities.whereType<BlockFunctionBody>().first;
    final block = blockFuncBody.childEntities.whereType<Block>().first;
    // final blockExpression = block.childEntities.whereType<ExpressionStatement>().first;
    return block;
  }

  void updateAllSelectors({required Selector pasteSelector, required int changedLengthTo}) {
    final newSelector =
        Selector(pasteSelector.from, pasteSelector.from + changedLengthTo);
    final deltaChange = changedLengthTo - pasteSelector.length;
    for (var myFunc in this.items) {
      if (myFunc.selector.to < pasteSelector.from) {
        // do nothing
      } else if (myFunc.selector.from > newSelector.to) {
        myFunc.selector.addOffset(deltaChange);
      } else if (myFunc.selector.from <= pasteSelector.from &&
          myFunc.selector.to >= pasteSelector.to) {
        myFunc.selector.to += deltaChange;
      }
      var funcStr = myFunc.toString();
      print(funcStr);
    }
  }

  List<FunctionItem> getFunctionItemByMethodName(String funcName) {
    return this
        .items
        .where((element) => element.methodName == funcName)
        .toList();
  }
}
