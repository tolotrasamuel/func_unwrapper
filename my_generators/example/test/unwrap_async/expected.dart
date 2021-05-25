import 'package:example_usage/model.dart';
import 'package:example_usage/model.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_generators/annotations.dart';

// sss
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
  await (String hi) async {
    await Future.delayed(Duration.zero);
    when(cat!.sound()).thenReturn("Woof");
  }("hi");
  dog = Dog(cat);
  final sound = dog.sayHi();
  expect(sound, "Woof");
  verify(cat!.sound());
}

void expectCatWalked() {
  verify(cat!.walk());
}

void main() {
  group('Dog Cat Play', () {
    setUp(() {
      cat = MockCat();
    });

    test('Dog woof', () async {
      await (String hi) async {
        await Future.delayed(Duration.zero);
        when(cat!.sound()).thenReturn("Woof");
      }("hi");

      dog = Dog(cat);
      final sound = dog.sayHi();
      expect(sound, "Woof");
      verify(cat!.sound());
    });

    test('Dog woof then jump', () async {
      await (String hi) async {
        await Future.delayed(Duration.zero);
        when(cat!.sound()).thenReturn("Woof");
      }("hi");

      dog = Dog(cat);
      final sound = dog.sayHi();
      expect(sound, "Woof");
      verify(cat!.sound());
      // setupCatWalkstub();
      await Future.delayed(Duration.zero);
      when(cat!.walk()).thenReturn(2);
      // setupCatWalkstub();
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
