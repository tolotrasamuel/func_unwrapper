import 'package:example_usage/model.dart';
import 'package:example_usage/model.mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:my_generators/annotations.dart';
import 'package:test/test.dart';

// ssss
MockCat? cat;
late Dog dog;

@UnWrap()
void testParam(String foo, String? bar, [String baz = "234"]) {
  print(foo + (bar ?? "bar") + baz);
}

@UnWrap()
void testParamNamed(String foo, String? bar,
    {required int a, int? b, int c = 23}) {
  print(foo + (bar ?? "bar") + '${a + (b ?? 69) + c}');
}

void testParams() {
  testParam("foo", null);
  testParam("foo", null, "baz");
  testParamNamed("foo", "bar", a: 3, c: 23);
}

@UnWrap()
void setupCatSoundStub({required String woof}) {
  print("Hi");
  when(cat!.sound()).thenReturn(woof);
}

@UnWrap()
void setupCatWalkstub() {
  when(cat!.walk()).thenReturn(2);
}

@UnWrap()
void expectCatCalled() {
  verify(cat!.sound());
}

@UnWrap()
void testDogWoof(String woof) {
  setupCatSoundStub(woof: woof);
  dog = Dog(cat);
  final sound = dog.sayHi();
  expect(sound, woof);
  expectCatCalled();
}

void expectCatWalked() {
  verify(cat!.walk());
}

void main() {
  group('Dog Cat Play', () {
    setUp(() {
      cat = MockCat();
    });

    test('Dog woof', () {
      testDogWoof("Woof");
      testDogWoof("Waaf");
    });

    test('Dog woof then jump', () {
      testDogWoof("Woof");
      setupCatWalkstub();
      final steps = dog.jump();
      expect(steps, 2);
      expectCatWalked();
    });
  });
}
