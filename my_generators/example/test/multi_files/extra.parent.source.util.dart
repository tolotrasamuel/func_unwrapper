import 'package:my_generators/annotations.dart';

import 'extra_parent_models.dart';
import 'main/inner/baz.dart';

@UnWrap()
void barFromParent() {
  var bar = Bar();
  var baz = Baz();
}
