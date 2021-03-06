import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:my_generators/annotations.dart';
import 'package:my_generators/src/model/file_content.dart';
import 'package:my_generators/src/model/function_item.dart';
import 'package:my_generators/src/model/selector.dart';
import 'package:my_generators/src/utils/utils.dart';
import 'package:source_gen/source_gen.dart';

import 'utils/extensions.dart';

class LibraryResolver {
  TypeChecker get typeChecker => TypeChecker.fromRuntime(UnWrap);

  final List<FunctionItem> items = [];
  // FileContent fileContent;
  // List<LibraryResolver> libResolvers = [];
  bool _completed = true;
  final LibraryReader library;
  final BuildStep buildStep;

  LibraryResolver({
    required this.library,
    required this.buildStep,
  });

  resolve() async {
    items.clear();
    // if (!_completed) {
    //   print(
    //       "Heyyy! attempt to reassign the buildStep while it is not completed");
    //   print("And this new build step is ${isCompleted(buildStep)} "
    //       "while the current build step is ${isCompleted(this.buildStep)}");
    //   return null;
    // }
    _completed = false;
    final inputId = buildStep.inputId;
    print("Unwrapping new file. Function Cache cleared. ${inputId.uri.path}");
    final fileContent = await resolveLib(library.element, inputId);
    if (fileContent == null) {
      print("Early exist. Possibly because of a BuildStepCompletedException");
      _completed = true;
      return null;
    }
    final imports = fileContent.imports.toSet().toList().map((locationItem) {
      final currentPath = (inputId.uri.path);
      return locationToImport(
        locationItem: locationItem,
        currentPath: currentPath,
      );
    }).whereType<String>();
    _completed = true;
    return "${imports.join("\n")}\n${fileContent.content}";
  }

  /// Somehow, when running in watch mode, this error happens suddenly
  /// while looping through the allElements (Something completes the buildStep
  /// before we finish returning a string value)
  /// It could because the file has changed (we are editing it while building)
  Resolver? resolver() {
    try {
      return this.buildStep.resolver;
    } catch (e, trace) {
      print('Possible BuildStepCompletedException $e');
      print(trace);
      return null;
    }
  }

  /// Same comment as [resolver]
  Future<String?> readAsString(AssetId inputId) async {
    try {
      return await buildStep.readAsString(inputId);
    } catch (e, trace) {
      print('Possible BuildStepCompletedException $e');
      print(trace);
      return null;
    }
  }

  Future<FileContent?> resolveLib(
      LibraryElement element, AssetId inputId) async {
    print("Resolving  lib. ${inputId.uri.path}");

    /// we are taking this content early because buildStep may expire,
    /// we don't want to return null because the generated file wil lbe deleted
    final content = await readAsString(inputId);

    final externalLib = element.importedLibraries
        .where((element) => element.identifier.endsWith(".source.util.dart"));
    final imports = element.importedLibraries.map((e) => e.identifier).toList();
    if (externalLib.isNotEmpty) {
      for (var libElment in externalLib) {
        final assetId = await resolver()?.assetIdForElement(libElment);
        if (assetId == null) continue;
        final fileContent = await resolveLib(libElment, assetId);
        if (fileContent == null) continue;
        imports.addAll(fileContent.imports);
      }
    }
    // libResolvers.add(LibraryResolver(element.identifier));

    if (content == null) return null;
    final fileContent = FileContent(content, 0, element.identifier, imports);
    final library = LibraryReader(element);

    final annotations = library.annotatedWith(typeChecker).toList();

    for (var element in annotations) {
      // print("All topLevel functions in ${fileContent.fileName} "
      //     "${element.runtimeType}  ${element.toString()}}");
      var astNode =
          await resolver()?.astNodeFor(element.element, resolve: true);
      if (astNode != null) {
        buildFunctions(astNode, fileContent);
      }
    }
    // print("Resolving  lib: ${inputId.uri.path} ");

    var i = 0;
    for (var element in library.allElements) {
      i++;
      var astNode = await resolver()?.astNodeFor(element, resolve: true);
      // print("${element.runtimeType} $i runtimeType ${element.toString()}}");
      if (astNode != null) {
        resolveFunction(astNode, fileContent);
      }
    }

    return fileContent;
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
      if (funcName == "barFromParent") {
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
      if (invokedMethod.methodName == "barFromParent") {
        print("break here");
      }

      // parent because we need to take into account the trailing semicolumn;
      final nodeTarget = methodInvocation.parent!;

      // final copySelector = existing.first.selector;
      final argumentList = getArgFromMethodInvocation(methodInvocation);
      var replacement = "";
      try {
        // this may fail due to range error caused by using build_runner watch and utils has changed
        replacement = invokedMethod.toStringCalledWith(argumentList);
      } catch (e, trace) {
        print("Possible range error $e. Please relaunch. $trace");
      }

      // +1 to remove the trailing left by the selector (not sure but unit test passed)
      final pasteSelector$Zero =
          Selector(nodeTarget.offset, nodeTarget.end + 1);
      final pasteSelector = pasteSelector$Zero..addOffset(fileContent.offset);

      try {
        // this may fail due to range error caused by using build_runner watch and utils has changed
        fileContent.replaceAt(
          pasteAt: pasteSelector,
          replacement: replacement,
        );
      } catch (e, trace) {
        print("Possible range error $e. Please relaunch. $trace");
        replacement = "";
      }
      updateAllSelectors(
        pasteSelector: pasteSelector,
        changedLengthTo: replacement.length,
        fileContent: fileContent,
      );

      if (invokedMethod.methodName == "barFromParent") {
        print(items.length);
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
    if (astNode == null || astNode is! FunctionDeclaration) {
      return;
    }
    var funcDeclaration = astNode as FunctionDeclaration;

    var metadata = funcDeclaration.metadata.whereType<Annotation>().firstOrNull;
    if (metadata == null) return;
    // final toUnwrap = metadata.childEntities
    //     .whereType<SimpleIdentifier>()
    //     .where((element) => element.name == "UnWrap")
    //     .isNotEmpty;
    // if (!toUnwrap) return;
    final block = getFuncBodyFromFuncDeclaration(funcDeclaration);
    final paramList = getFuncParamFromFuncDeclaration(funcDeclaration);
    if (paramList == null || block == null) {
      return;
    }
    var methodName = getFuncNameFromFuncDeclaration(funcDeclaration);
    final existing = getFunctionItemByMethodName(methodName);
    if (existing.isNotEmpty) {
      print("Warning, method $methodName already declared at both: "
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
      if (myFunc.methodName == "testDogWaaf") {
        print("break here");
      }
      // File of the function hasn't changed. we just read the function
      if (myFunc.file.fileName != fileContent.fileName) {
        continue;
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
          myFunc.selector.to >= pasteSelector.from) {
        myFunc.selector.to += deltaChange;
      }

      var funcStr = myFunc.toString();
      var content = (funcStr);
      if (myFunc.methodName == "testDogWaaf") {
        print("break here");
      }
    }
  }

  List<FunctionItem> getFunctionItemByMethodName(String funcName) {
    return items.where((element) => element.methodName == funcName).toList();
  }
}

class FunctionUnwrap extends Generator {
  bool? isCompleted(BuildStep buildStep) {
    try {
      buildStep.resolver;
    } catch (e) {
      if (e is BuildStepCompletedException) {
        return true;
      }
      return null;
    }
    return false;
  }

  late LibraryResolver latest;

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final libResolver = LibraryResolver(
      library: library,
      buildStep: buildStep,
    );
    // this.latest = libResolver;
    final ans = await libResolver.resolve();
    return ans;
  }
}
