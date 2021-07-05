import 'dart:async';

import 'package:mockito/mockito.dart';

abstract class BaseOutlet {
  late Mock mock;
}

class StubFuture<T> {
  late Completer<T> stub;
  late Function resetAction;
  void complete([FutureOr<T>? value]) {
    stub.complete(value);
  }

  void reset() {
    stub = Completer();
    resetAction();
  }

  void setReset(Function() _resetAction) {
    resetAction = _resetAction;
  }
}

class StubStream<T> {
  late StreamController<T> stub;
  late Function resetAction;
  void add(T event) {
    stub.add(event);
  }

  void reset() {
    stub = StreamController.broadcast();
    resetAction();
  }

  void setReset(Function() _resetAction) {
    resetAction = _resetAction;
  }
}
