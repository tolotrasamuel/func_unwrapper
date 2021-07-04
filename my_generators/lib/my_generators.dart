import 'package:build/build.dart';
import 'package:my_generators/src/function_unwrap.dart';
import 'package:my_generators/src/mock_outlet_generator.dart';
import 'package:source_gen/source_gen.dart';

import 'src/info_generator.dart';

Builder functionUnwrapBuild(BuilderOptions options) => LibraryBuilder(
      FunctionUnwrap(),
      generatedExtension: '.unwrapped_test.dart',
    );

Builder infoGeneratorBuilder(BuilderOptions options) => LibraryBuilder(
      InfoGenerator(),
      generatedExtension: '.info.dart',
    );

Builder mockOutletGenerator(BuilderOptions options) => LibraryBuilder(
      MockOutletGenerator(),
      generatedExtension: '.outlets.dart',
    );
