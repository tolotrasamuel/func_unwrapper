import 'dart:async';

import 'package:build/build.dart';
import 'package:my_generators/src/model/generate_file_info.dart';
import 'package:source_gen/source_gen.dart';

class InfoGenerator extends Generator {
  TypeChecker get typeChecker => TypeChecker.fromRuntime(GenerateFileInfo);

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final annotations = library.annotatedWith(typeChecker);
    if (annotations.isEmpty) return null;

    var buffer = StringBuffer();

    buffer.writeln('var \$currentPath = "${buildStep.inputId.path}";');

    return buffer.toString();
  }
}
