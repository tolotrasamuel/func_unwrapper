// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: FunctionUnwrap
// **************************************************************************

import 'package:example_usage/src/model.dart';
import 'package:example_usage/src/test/main_test.source.util.dart';
import 'package:example_usage/src/unwrap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

@UnWrap()
void expectCatCalled() {
  verify(cat.sound());
}

@UnWrap()
void testDogWoof() {
  setupCatSoundStub();
  dog = Dog(cat);
  final sound = dog.sayHi();
  expect(sound, "Woof");
  verify(cat.sound());
}

void expectCatWalked() {
  verify(cat.walk());
}

void main() {
  group('Dog Cat Play', () {
    setUp(() {
      cat = MockCat();
    });

    test('Dog woof', () {
      setupCatSoundStub();
      dog = Dog(cat);
      final sound = dog.sayHi();
      expect(sound, "Woof");
      verify(cat.sound());
    });

    test('Dog woof then jump', () {
      setupCatSoundStub();
      dog = Dog(cat);
      final sound = dog.sayHi();
      expect(sound, "Woof");
      verify(cat.sound());
      setupCatWalkstub();
      final steps = dog.jump();
      expect(steps, 2);
      expectCatWalked();
    });
  });
}
