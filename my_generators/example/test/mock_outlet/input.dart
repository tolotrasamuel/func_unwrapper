import 'package:example_usage/model.dart';
import 'package:mockito/annotations.dart';

/// ss
class SomeAnnotation {
  const SomeAnnotation();
}

@SomeAnnotation()
class SomeService {
  Future<int> bar(Cat man) {
    return Future.delayed(Duration(seconds: 3));
  }

  Future<Dog> foo(String foune, [bool clean = true]) async {
    return await Future.value(Dog(Cat()));
  }

  Future<T> runTransaction<T>() async {
    return Future.value();
  }

  // Private should be ignored
  Future<int> _bar(String man) {
    return Future.delayed(Duration(seconds: 3));
  }

  Future<int> _foo(String foune, [bool clean = true]) async {
    return await Future.value(3);
  }
}

class SomeController {
  Future<int> bar(String key,
      {String glass = "water", required Dog test, String? zero}) {
    return Future.delayed(Duration(seconds: 3));
  }

  Future<int> foo() async {
    return await Future.value(3);
  }

  static Future<int> fooStatic() async {
    return await Future.value(3);
  }

  @SomeAnnotation()
  Stream<int> baz() {
    return Future.value(2).asStream();
  }

  faz() async {
    return await Future.value(3);
  }

  // Private should be ignored
  Future<int> _bar(String key,
      {String glass = "water", required String test, String? zero}) {
    return Future.delayed(Duration(seconds: 3));
  }

  Future<int> _foo() async {
    return await Future.value(3);
  }

  @SomeAnnotation()
  Stream<int> _baz() {
    return Future.value(2).asStream();
  }

  _faz() async {
    return await Future.value(3);
  }
}

@GenerateMocks([
  SomeService,
  SomeController,
], customMocks: [])
void main() {}
