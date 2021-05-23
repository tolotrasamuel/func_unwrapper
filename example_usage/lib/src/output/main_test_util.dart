import 'package:example_usage/src/model.dart';
import 'package:example_usage/src/unwrap.dart';
import 'package:mockito/mockito.dart';

late MockCat cat;
Dog? dog;
@UnWrap()
void setupCatSoundStub() {
  when(cat.sound()).thenReturn("Woof");
}

@UnWrap()
void setupCatWalkstub() {
  when(cat.walk()).thenReturn(2);
}
