import 'package:example_usage/model.dart';
import 'package:example_usage/model.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_generators/annotations.dart';

import 'extra.source.util.dart';

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
  group('Multi files -  Dog Cat Play', () {
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
