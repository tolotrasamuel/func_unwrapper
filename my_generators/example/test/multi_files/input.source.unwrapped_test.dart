// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: FunctionUnwrap
// **************************************************************************

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
  // Setup Cat Sound Stub setupCatSoundStub()
  print("Hi");
  when(cat!.sound()).thenReturn("Woof");

  dog = Dog(cat);
  final sound = dog.sayHi();
  expect(sound, "Woof");
  // Expect Cat Called expectCatCalled()
  verify(cat!.sound());
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
      // Test Dog Woof testDogWoof()
      // Setup Cat Sound Stub setupCatSoundStub()
      print("Hi");
      when(cat!.sound()).thenReturn("Woof");

      dog = Dog(cat);
      final sound = dog.sayHi();
      expect(sound, "Woof");
      // Expect Cat Called expectCatCalled()
      verify(cat!.sound());
    });

    test('Dog woof then jump', () {
      // Test Dog Woof testDogWoof()
      // Setup Cat Sound Stub setupCatSoundStub()
      print("Hi");
      when(cat!.sound()).thenReturn("Woof");

      dog = Dog(cat);
      final sound = dog.sayHi();
      expect(sound, "Woof");
      // Expect Cat Called expectCatCalled()
      verify(cat!.sound());

      // Setup Cat Walkstub setupCatWalkstub()
      when(cat!.walk()).thenReturn(2);

      final steps = dog.jump();
      expect(steps, 2);
      expectCatWalked();
    });
  });
}
