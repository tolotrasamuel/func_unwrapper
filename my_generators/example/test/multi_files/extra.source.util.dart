import 'package:example_usage/model.dart';
import 'package:example_usage/model.mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:my_generators/annotations.dart';

MockCat? cat;
late Dog dog;
@UnWrap()
void setupCatSoundStub() {
  print("Hi");
  when(cat!.sound()).thenReturn("Woof");
}

@UnWrap()
void setupCatWalkstub() {
  when(cat!.walk()).thenReturn(2);
}

@UnWrap()
void expectCatCalled() {
  verify(cat!.sound());
}
