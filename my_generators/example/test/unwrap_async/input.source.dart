import 'package:example_usage/model.dart';
import 'package:example_usage/model.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_generators/annotations.dart';

// ssss
MockCat? cat;
late Dog dog;
@UnWrap()
Future<void> setupCatSoundStub(String hi) async {
  await Future.delayed(Duration.zero);
  when(cat!.sound()).thenReturn("Woof");
}

@UnWrap()
Future<void> setupCatWalkstub() async {
  await Future.delayed(Duration.zero);
  when(cat!.walk()).thenReturn(2);
}

@UnWrap()
void expectCatCalled() {
  verify(cat!.sound());
}

@UnWrap()
Future<void> testDogWoof() async {
  await setupCatSoundStub("hi");
  dog = Dog(cat);
  final sound = dog.sayHi();
  expect(sound, "Woof");
  expectCatCalled();
}

void expectCatWalked() {
  verify(cat!.walk());
}

@GenerateFileInfo()
void main() {
  group('Dog Cat Play', () {
    setUp(() {
      cat = MockCat();
    });

    test('Dog woof', () async {
      await testDogWoof();
    });

    test('Dog woof then jump', () async {
      await testDogWoof();
      // awaited and no parameters should just unwrap async
      await setupCatWalkstub();
      // non awaited should be partially unwrap async
      setupCatWalkstub();
      final steps = dog.jump();
      expect(steps, 2);
      expectCatWalked();
    });
  });
}
