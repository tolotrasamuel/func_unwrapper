import 'package:build/build.dart';
import 'package:my_generators/src/function_unwrap.dart';
import 'package:source_gen/source_gen.dart';

import 'src/class_extras_generator.dart';
import 'src/info_generator.dart';
import 'src/serialize_generator.dart';

Builder infoGeneratorBuilder(BuilderOptions options) =>
    SharedPartBuilder([InfoGenerator()], 'info');

Builder classExtrasGeneratorBuilder(BuilderOptions options) =>
    SharedPartBuilder([ClassExtrasGenerator()], 'fields');

Builder serializeGeneratorBuilder(BuilderOptions options) =>
    SharedPartBuilder([SerializeGenerator()], 'serialize');

Builder functionUnwrapBuild(BuilderOptions options) => LibraryBuilder(
      FunctionUnwrap(),
      generatedExtension: '.unwrapped_test.dart',
    );
