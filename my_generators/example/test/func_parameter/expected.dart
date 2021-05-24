import 'package:example_usage/model.dart';
import 'package:example_usage/model.mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:my_generators/annotations.dart';
import 'package:test/test.dart';

// ssss
MockCat? cat;
late Dog dog;

@UnWrap()
void testParam(String foo, String? bar, [String baz = "234"]) {
  print(foo + (bar ?? "bar") + baz);
}

@UnWrap()
void testParamAllOptional([String baz = "234"]) {
  print(baz);
}

@UnWrap()
void testParamNamed(String foo, String? bar,
    {required int a, int? b, int c = 23}) {
  print(foo + (bar ?? "bar") + '${a + (b ?? 69) + c}');
}

@UnWrap()
void testNamedParamAllOptional({String? baz}) {
  print(baz);
}

void testParams() {
  // Test Param
  (String foo, String? bar, [String baz = "234"]) {
    print(foo + (bar ?? "bar") + baz);
  }("foo", null);

  // Test Param
  (String foo, String? bar, [String baz = "234"]) {
    print(foo + (bar ?? "bar") + baz);
  }("foo", null, "baz");

  // Test Param Named
  (String foo, String? bar, {required int a, int? b, int c = 23}) {
    print(foo + (bar ?? "bar") + '${a + (b ?? 69) + c}');
  }("foo", "bar", a: 3, c: 23);

  // Test Param All Options
  ([String baz = "234"]) {
    print(baz);
  }();

  // Test Param Named All Options
  ({String? baz}) {
    print(baz);
  }();
}

@UnWrap()
void setupCatSoundStub({required String woof}) {
  print("Hi");
  when(cat!.sound()).thenReturn(woof);
}

@UnWrap()
void setupCatWalkstub() {
  when(cat!.walk()).thenReturn(2);
}

@UnWrap()
void expectCatCalled() {
  verify(cat!.sound());
}

@UnWrap()
void testDogWoof(String woof) {
  // Setup Cat Sound Stub setupCatSoundStub();
  ({required String woof}) {
    print("Hi");
    when(cat!.sound()).thenReturn(woof);
  }(woof: woof);
  dog = Dog(cat);
  final sound = dog.sayHi();
  expect(sound, woof);
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

    test('Dog woof', () {
      // Test Dog Woof testDogWoof("Woof");
      (String woof) {
        // Setup Cat Sound Stub setupCatSoundStub()
        ({required String woof}) {
          print("Hi");
          when(cat!.sound()).thenReturn(woof);
        }(woof: woof);

        dog = Dog(cat);
        final sound = dog.sayHi();
        expect(sound, woof);
        verify(cat!.sound());
      }("Woof");

      // Test Dog Woof testDogWoof("Waaf");
      (String woof) {
        // Setup Cat Sound Stub setupCatSoundStub()
        ({required String woof}) {
          print("Hi");
          when(cat!.sound()).thenReturn(woof);
        }(woof: woof);

        dog = Dog(cat);
        final sound = dog.sayHi();
        expect(sound, woof);
        verify(cat!.sound());
      }("Waaf");
    });

    test('Dog woof then jump', () {
      // Test Dog Woof testDogWoof("Woof");
      (String woof) {
        // Setup Cat Sound Stub setupCatSoundStub()
        ({required String woof}) {
          print("Hi");
          when(cat!.sound()).thenReturn(woof);
        }(woof: woof);

        dog = Dog(cat);
        final sound = dog.sayHi();
        expect(sound, woof);
        verify(cat!.sound());
      }("Woof");

      when(cat!.walk()).thenReturn(2);
      final steps = dog.jump();
      expect(steps, 2);
      expectCatWalked();
    });
  });
}
