import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:mockito/annotations.dart';
import 'package:my_generators/src/utils/utils.dart';
import 'package:source_gen/source_gen.dart';

import 'utils/extensions.dart';

enum OutletType { future, stream }

class ClassOutLetResult {
  final List<String> imports;
  final String content;
  final String className;

  ClassOutLetResult({
    required this.imports,
    required this.content,
    required this.className,
  });
}

class Outlet {
  // final OutletType type;
  final String methodName;
  final FormalParameterList parameterList;
  final TypeName typeNameAst;

  get isFuture => typeNameAst.toString().contains("Future");
  get isStream => typeNameAst.toString().contains("Stream");

  Outlet({
    // required this.type,
    required this.methodName,
    required this.parameterList,
    required this.typeNameAst,
  });

  get type => isStream ? OutletType.stream : OutletType.future;
}

class MockOutletGenerator extends GeneratorForAnnotation<GenerateMocks> {
  @override
  FutureOr<String?> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final buffer = StringBuffer();

    final read = annotation.read('classes');
    final classes = read.objectValue.toListValue();
    if (classes == null) return null;
    final classResults = <ClassOutLetResult>[];
    for (final classType in classes) {
      final result = await resolveClass(classType, buildStep);
      if (result == null) continue;
      classResults.add(result);
      // buffer.writeln(str);
    }
    final library = element.library;
    if (classResults.isEmpty || library == null) return null;
    final currentLocation = library.location.toString();
    final mockLocation = currentLocation.replaceFirst(".dart", ".mocks.dart");
    final currentPath = buildStep.inputId.uri.path;
    final outletLocation = currentPath.replaceFirst(".dart", ".outlets.dart");

    /// Writing library dependency imports
    buffer.writeln("""
      import 'dart:async';
      import 'package:get_it/get_it.dart';
      import 'package:mockito/mockito.dart';
      ${locationToImport(locationItem: mockLocation, currentPath: currentPath)}
    """);

    /// Writing imports to buffer
    final imports = [];
    classResults.forEach((element) {
      imports.addAll(element.imports);
    });
    imports.toSet().forEach((importPath) {
      final str = locationToImport(
        locationItem: importPath,
        currentPath: outletLocation,
      );
      if (str == null) return;
      buffer.writeln(str);
    });

    /// Writing wrapper outlet
    buffer.writeln('class MockOutlet {');
    for (final classOutletResult in classResults) {
      final classOutletName =
          classNameToOutletName(classOutletResult.className);
      final instanceName = upperCamelToLowerCal(classOutletName);
      buffer.writeln(
        'final $classOutletName $instanceName = $classOutletName();',
      );
    }
    buffer.writeln('}');

    /// Writing class content to buffer
    classResults.forEach((element) {
      buffer.writeln(element.content);
    });
    return buffer.toString();
  }

  Future<ClassOutLetResult?> resolveClass(
    DartObject classType,
    BuildStep buildStep,
  ) async {
    final outlets = <Outlet>[];
    final typeToMock = classType.toTypeValue();
    final element = typeToMock?.element;
    if (element == null) return null;
    final astNode = await buildStep.resolver.astNodeFor(element, resolve: true);
    if (astNode == null) return null;
    if (astNode is! ClassDeclaration) return null;

    final methodDeclarations =
        astNode.childEntities.whereType<MethodDeclaration>().toList();
    for (final element in methodDeclarations) {
      final methodName = element.name.toString();
      if (Identifier.isPrivateName(methodName)) continue;
      final children = element.childEntities;
      final typeNameAst = children.whereType<TypeName>().firstOrNull;
      if (typeNameAst == null) continue;

      final parameterList =
          children.whereType<FormalParameterList>().firstOrNull;
      if (parameterList == null) continue;
      final outlet = Outlet(
        typeNameAst: typeNameAst,
        methodName: methodName,
        parameterList: parameterList,
      );
      if (!outlet.isFuture && !outlet.isStream) continue;
      outlets.add(outlet);
    }

    if (outlets.isEmpty) return null;
    final className = element.displayName;
    final str = outletsToString(className, outlets);
    final classLocation = element.library?.location.toString();
    if (classLocation == null) return null; // impossible to return but well...
    return ClassOutLetResult(
      imports: [classLocation],
      content: str,
      className: className,
    );
  }

  String classNameToOutletName(String className) {
    return "Outlet$className";
  }

  String outletsToString(String className, List<Outlet> outlets) {
    final buffer = StringBuffer();
    final outletClassName = classNameToOutletName(className);
    final mockClassName = "Mock$className";
    buffer.writeln('class $outletClassName {');

    /// Creating the outlets
    for (final outlet in outlets) {
      switch (outlet.type) {
        case OutletType.future:
          buffer.write(
              "${outlet.typeNameAst.toString().replaceFirst("Future", "final Completer")} ");
          buffer.write("${outlet.methodName} ");
          buffer.write(" = Completer();");
          break;
        case OutletType.stream:
          buffer.write(
              "${outlet.typeNameAst.toString().replaceFirst("Stream", "final StreamController")} ");
          buffer.write("${outlet.methodName} ");
          buffer.write(" = StreamController.broadcast();");
          break;
      }
    }

    buffer.writeln();

    /// Initiating the mock instances
    buffer.writeln('''
        final $mockClassName mock =
          GetIt.instance.get<$className>() as $mockClassName;
    ''');

    buffer.writeln();

    /// Attaching the mock instances with the outlets
    buffer.writeln("$outletClassName() {");
    for (final outlet in outlets) {
      outlet.parameterList;
      buffer.writeln();
      final inlineParameters = [];
      final namedParameters = [];
      for (final element in outlet.parameterList.childEntities) {
        if (element is! SimpleFormalParameter &&
            element is! DefaultFormalParameter) continue;
        if (element is DefaultFormalParameter && element.isNamed) {
          namedParameters.add(element);
        } else {
          inlineParameters.add(element);
        }
      }
      final methodName = outlet.methodName;
      final nothing = '';
      buffer.writeln("""
          when(mock.${outlet.methodName}(
            ${inlineParameters.map((e) => "any").join(",")}
            ${inlineParameters.isNotEmpty ? "," : nothing}
            ${namedParameters.map((e) => "${e.identifier}: anyNamed('${e.identifier}')").join(",")}
            ${namedParameters.isNotEmpty ? "," : nothing}
          )).
            ${outlet.isFuture ? "thenAnswer((_) async => $methodName.future);" : nothing}
            ${outlet.isStream ? "thenReturn($methodName.stream);" : nothing}
          """);
    }
    buffer.writeln('}');

    buffer.writeln('}');

    return buffer.toString();
  }
}
