// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: FunctionUnwrap
// **************************************************************************

import 'package:example_usage/src/model.dart';
import 'package:example_usage/src/unwrap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// ssss
MockCat cat;
Dog dog;
@UnWrap()
void setupCatSoundStub() {
  print("Hi");
  when(cat.sound()).thenReturn("Woof");
}

@UnWrap()
void setupCatWalkstub() {
  when(cat.walk()).thenReturn(2);
}

@UnWrap()
void expectCatCalled() {
  verify(cat.sound());
}

@UnWrap()
void testDogWoof() {
  print("Hi");
  when(cat.sound()).thenReturn("Woof");
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
      print("Hi");
      when(cat.sound()).thenReturn("Woof");
      dog = Dog(cat);
      final sound = dog.sayHi();
      expect(sound, "Woof");
      verify(cat.sound());
    });

    test('Dog woof then jump', () {
      print("Hi");
      when(cat.sound()).thenReturn("Woof");
      dog = Dog(cat);
      final sound = dog.sayHi();
      expect(sound, "Woof");
      verify(cat.sound());
      when(cat.walk()).thenReturn(2);
      final steps = dog.jump();
      expect(steps, 2);
      expectCatWalked();
    });
  });
}