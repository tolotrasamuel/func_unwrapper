import 'dart:async';

import 'package:mockito/mockito.dart';

abstract class BaseOutlet {
  late Mock mock;
}

class StubFuture<T> {
  Completer<T> get stub => _stub!;
  Completer<T>? _stub;
  late Function resetAction;
  void complete([FutureOr<T>? value]) {
    stub.complete(value);
  }

  void reset() {
    _stub = Completer();
    resetAction();
  }

  void setReset(Function() _resetAction) {
    resetAction = _resetAction;
  }
}

class StubStream<T> {
  StreamController<T> get stub => _stub!;
  StreamController<T>? _stub;
  late Function resetAction;
  void add(T event) {
    stub.add(event);
  }

  void reset() {
    _stub = StreamController.broadcast();
    resetAction();
  }

  void setReset(Function() _resetAction) {
    resetAction = _resetAction;
  }
}
