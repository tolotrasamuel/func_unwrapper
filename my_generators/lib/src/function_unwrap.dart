import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:my_generators/src/model/file_content.dart';
import 'package:my_generators/src/model/function_item.dart';
import 'package:my_generators/src/model/selector.dart';
import 'package:source_gen/source_gen.dart';

extension MyIterable<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;

  T? firstWhereOrNull(bool Function(T element) test) {
    final list = where(test);
    return list.isEmpty ? null : list.first;
  }
}

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
      print("All topLevel functions in ${fileContent.fileName} "
          "${element.runtimeType}  ${element.toString()}}");
      var astNode = await buildStep.resolver.astNodeFor(element, resolve: true);
      if (astNode != null) {
        buildFunctions(astNode, fileContent);
      }
    }

    var i = 0;
    for (var element in library.allElements) {
      var astNode = await buildStep.resolver.astNodeFor(element, resolve: true);
      // print("${element.runtimeType} ${i++} runtimeType ${element.toString()}}");
      if (astNode != null) {
        resolveFunction(astNode, fileContent);
      }
    }

    return fileContent.content;
  }

  void resolveFunction(AstNode nodeChild, FileContent fileContent) {
    recurse(nodeChild, (AstNode node) {
      if (node is! MethodInvocation) {
        return;
      }

      var methodInvocation = node as MethodInvocation;
      final funcName = methodInvocation.childEntities
          .whereType<SimpleIdentifier>()
          .firstOrNull;
      if (funcName == null) return;
      if (funcName == "testDogWoof") {
        print("here");
      }
      final existing = this.getFunctionItemByMethodName(funcName.name);
      if (existing.isEmpty) {
        return;
      }
      final invokedMethod = existing.first;
      if (invokedMethod.unwrapped != true) {
        resolveFunction(invokedMethod.block, fileContent);
        invokedMethod.unwrapped = true;
      }
      if (invokedMethod.methodName == "expectCatCalled") {
        print("break here");
      }

      // parent because we need to take into account the trailing semicolumn;
      final nodeTarget = methodInvocation.parent!;

      // final copySelector = existing.first.selector;
      final argumentList = getArgFromMethodInvocation(methodInvocation);
      final replacement = invokedMethod.toStringCalledWith(argumentList);
      final pasteSelector$Zero = Selector(nodeTarget.offset, nodeTarget.end);
      final pasteSelector = pasteSelector$Zero..addOffset(fileContent.offset);

      fileContent.replaceAt(
        pasteAt: pasteSelector,
        replacement: replacement,
      );
      updateAllSelectors(
        pasteSelector: pasteSelector,
        changedLengthTo: replacement.length,
        fileContent: fileContent,
      );
      print(items.length);
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
    if (astNode == null || astNode is! FunctionDeclaration) {
      return;
    }
    var funcDeclaration = astNode as FunctionDeclaration;
    var metadata = funcDeclaration.metadata.whereType<Annotation>().firstOrNull;
    if (metadata == null) return;
    final toUnwrap = metadata.childEntities
        .whereType<SimpleIdentifier>()
        .where((element) => element.name == "UnWrap")
        .isNotEmpty;
    if (!toUnwrap) return;
    final block = getFuncBodyFromFuncDeclaration(funcDeclaration);
    final paramList = getFuncParamFromFuncDeclaration(funcDeclaration);
    if (paramList == null || block == null) {
      return;
    }
    var methodName = getFuncNameFromFuncDeclaration(funcDeclaration);
    final existing = getFunctionItemByMethodName(methodName);
    if (existing.isNotEmpty) {
      throw ("Warning, method $methodName already declared at both: "
          "${existing.first.file.fileName} and ${fileContent.fileName}. \n");
      return;
    }
    items.add(FunctionItem(
      file: fileContent,
      methodName: methodName,
      paramList: paramList,
      block: block,
      unwrapped: false,
      selector: FunctionItem.getBlockSelector(block),
    ));
  }

  String getFuncNameFromFuncDeclaration(FunctionDeclaration astNode) {
    return astNode.childEntities.whereType<SimpleIdentifier>().first.name;
  }

  Block? getFuncBodyFromFuncDeclaration(FunctionDeclaration astNode) {
    final funcExpression =
        astNode.childEntities.whereType<FunctionExpression>().firstOrNull;
    final blockFuncBody = funcExpression?.childEntities
        .whereType<BlockFunctionBody>()
        .firstOrNull;
    final block = blockFuncBody?.childEntities.whereType<Block>().firstOrNull;
    // final blockExpression = block.childEntities.whereType<ExpressionStatement>().first;
    return block;
  }

  FormalParameterList? getFuncParamFromFuncDeclaration(
      FunctionDeclaration astNode) {
    final funcExpression =
        astNode.childEntities.whereType<FunctionExpression>().firstOrNull;
    final paramList = funcExpression?.childEntities
        .whereType<FormalParameterList>()
        .firstOrNull;
    return paramList;
  }

  ArgumentList? getArgFromMethodInvocation(MethodInvocation astNode) {
    final shortList = astNode.childEntities.whereType<ArgumentList>();
    if (shortList.isEmpty) return null;
    final argList = shortList.first;
    return argList;
  }

  void updateAllSelectors({
    required Selector pasteSelector,
    required int changedLengthTo,
    required FileContent fileContent,
  }) {
    final newSelector = Selector(
      pasteSelector.from,
      pasteSelector.from + changedLengthTo,
    );
    final deltaChange = changedLengthTo - pasteSelector.length;

    for (var myFunc in items) {
      // File of the function hasn't changed. we just read the function
      if (myFunc.file.fileName != fileContent.fileName) {
        continue;
      }
      if (myFunc.methodName == "expectCatCalled") {
        print("break here");
      }
      // if my function is before paste selector
      if (myFunc.selector.to < pasteSelector.from) {
        // do nothing
      }
      // if my function is after paste selector
      else if (myFunc.selector.from > pasteSelector.to) {
        myFunc.selector.addOffset(deltaChange);
      }
      // if my function is updated inside
      else if (myFunc.selector.from <= pasteSelector.from &&
          myFunc.selector.to >= pasteSelector.to) {
        myFunc.selector.to += deltaChange;
      }
      var funcStr = myFunc.toString();
      var content = (funcStr);
    }
  }

  List<FunctionItem> getFunctionItemByMethodName(String funcName) {
    return this
        .items
        .where((element) => element.methodName == funcName)
        .toList();
  }
}
