import 'package:example_usage/model.dart';
import 'package:example_usage/model.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// d
MockCat? cat;
late Dog dog;
void expectCatWalked() {
  verify(cat!.walk());
}

void main() {
  group('Dog Cat Play', () {
    setUp(() {
      cat = MockCat();
    });

    test('Dog woof', () {
      // testDogWoof();
      // setupCatSoundStub();
      when(cat!.sound()).thenReturn("Woof");
      dog = Dog(cat);
      final sound = dog.sayHi();
      expect(sound, "Woof");
      // expectCatCalled();
      verify(cat!.sound());
    });

    test('Dog woof then jump', () {
      // testDogWoof();
      // setupCatSoundStub();
      when(cat!.sound()).thenReturn("Woof");
      dog = Dog(cat);
      final sound = dog.sayHi();
      expect(sound, "Woof");
      // expectCatCalled();
      verify(cat!.sound());
      // setupCatWalkstub();
      when(cat!.walk()).thenReturn(2);
      final steps = dog.jump();
      expect(steps, 2);
      expectCatWalked();
    });
  });
}
