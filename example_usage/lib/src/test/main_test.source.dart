import 'package:example_usage/src/model.dart';
import 'package:example_usage/src/test/main_test.source.util.dart';
import 'package:example_usage/src/unwrap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// d
@UnWrap()
void expectCatCalled() {
  verify(cat!.sound());
}

@UnWrap()
void testDogWoof() {
  setupCatSoundStub();
  dog = Dog(cat);
  final sound = dog.sayHi();
  expect(sound, "Woof");
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
      testDogWoof();
    });

    test('Dog woof then jump', () {
      testDogWoof();
      setupCatWalkstub();
      final steps = dog.jump();
      expect(steps, 2);
      expectCatWalked();
    });
  });
}
