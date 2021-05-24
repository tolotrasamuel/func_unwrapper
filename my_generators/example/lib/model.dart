import 'package:mockito/annotations.dart';

class Cat {
  String sound() => "Meow";
  int walk() => 4;
}

class Dog {
  final Cat? cat;

  Dog(this.cat);

  String sayHi() {
    return this.cat!.sound();
  }

  int jump() {
    return this.cat!.walk();
  }
}

@GenerateMocks([Cat])
void main() {}
