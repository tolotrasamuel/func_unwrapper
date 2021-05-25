// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: FunctionUnwrap
// **************************************************************************

import 'extra.source.util.dart';
import 'package:example_usage/model.mocks.dart';
import 'package:mockito/mockito.dart';
import 'dart:core';
import 'package:my_generators/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example_usage/model.dart';
import '../extra.parent.source.util.dart';
import '../extra_models.dart';
import '../extra_parent_models.dart';
import 'inner/baz.dart';
import 'package:example_usage/model.dart';
import 'package:example_usage/model.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_generators/annotations.dart';

import 'extra.source.util.dart';

// dd
@UnWrap()
void expectCatCalled() {
  verify(cat!.sound());
}

@UnWrap()
void testDogWaaf() {
  // Setup Cat Sound Stub setupCatSoundStub()
  final foo = Foo();
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
  // Bar bar()
  // Bar From Parent barFromParent()
  var bar = Bar();
  var baz = Baz();

  group('Multi files - Dog Cat Play', () {
    setUp(() {
      cat = MockCat();
    });

    test('Dog woof', () {
      // Test Dog Waaf testDogWaaf()
      // Setup Cat Sound Stub setupCatSoundStub()
      final foo = Foo();
      print("Hi");
      when(cat!.sound()).thenReturn("Woof");

      dog = Dog(cat);
      final sound = dog.sayHi();
      expect(sound, "Woof");
      // Expect Cat Called expectCatCalled()
      verify(cat!.sound());
    });

    test('Dog woof then jump', () {
      // Test Dog Waaf testDogWaaf()
      // Setup Cat Sound Stub setupCatSoundStub()
      final foo = Foo();
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
