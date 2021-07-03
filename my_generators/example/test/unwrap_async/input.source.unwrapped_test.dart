// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: FunctionUnwrap
// **************************************************************************

import 'package:my_generators/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example_usage/model.dart';
import 'dart:core';
import 'package:mockito/mockito.dart';
import 'package:example_usage/model.mocks.dart';
import 'package:example_usage/model.dart';
import 'package:example_usage/model.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_generators/annotations.dart';

// sssss
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
  // Setup Cat Sound Stub setupCatSoundStub()
  await (String hi) async {
    await Future.delayed(Duration.zero);
    when(cat!.sound()).thenReturn("Woof");
  }("hi");

  dog = Dog(cat);
  final sound = dog.sayHi();
  expect(sound, "Woof");
  // Expect Cat Called expectCatCalled()
  verify(cat!.sound());
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
      // Test Dog Woof testDogWoof()
      // Setup Cat Sound Stub setupCatSoundStub()
      await (String hi) async {
        await Future.delayed(Duration.zero);
        when(cat!.sound()).thenReturn("Woof");
      }("hi");

      dog = Dog(cat);
      final sound = dog.sayHi();
      expect(sound, "Woof");
      // Expect Cat Called expectCatCalled()
      verify(cat!.sound());
    });

    test('Dog woof then jump', () async {
      // Test Dog Woof testDogWoof()
      // Setup Cat Sound Stub setupCatSoundStub()
      await (String hi) async {
        await Future.delayed(Duration.zero);
        when(cat!.sound()).thenReturn("Woof");
      }("hi");

      dog = Dog(cat);
      final sound = dog.sayHi();
      expect(sound, "Woof");
      // Expect Cat Called expectCatCalled()
      verify(cat!.sound());

      // awaited and no parameters should just unwrap async
      // Setup Cat Walkstub setupCatWalkstub()
      await Future.delayed(Duration.zero);
      when(cat!.walk()).thenReturn(2);

      // non awaited should be partially unwrap async
      // Setup Cat Walkstub setupCatWalkstub()
      await () async {
        await Future.delayed(Duration.zero);
        when(cat!.walk()).thenReturn(2);
      }();
      final steps = dog.jump();
      expect(steps, 2);
      expectCatWalked();
    });
  });
}
