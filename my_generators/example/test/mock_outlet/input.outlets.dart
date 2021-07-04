// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MockOutletGenerator
// **************************************************************************

import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'input.mocks.dart';

import 'input.dart';
import 'package:example_usage/model.dart';
import 'package:mockito/annotations.dart';
import 'dart:core';

class Outlets {
  final OutletSomeService someService = OutletSomeService();
  final OutletSomeController someController = OutletSomeController();
}

class OutletSomeService {
  final Completer<int> bar = Completer();
  final Completer<Dog> foo = Completer();
  final MockSomeService mock =
      GetIt.instance.get<SomeService>() as MockSomeService;

  OutletSomeService() {
    when(mock.bar(
      any,
    )).thenAnswer((_) async => bar.future);

    when(mock.foo(
      any,
      any,
    )).thenAnswer((_) async => foo.future);
  }
}

class OutletSomeController {
  final Completer<int> bar = Completer();
  final Completer<int> foo = Completer();
  final StreamController<int> baz = StreamController.broadcast();
  final MockSomeController mock =
      GetIt.instance.get<SomeController>() as MockSomeController;

  OutletSomeController() {
    when(mock.bar(
      any,
      glass: anyNamed('glass'),
      test: anyNamed('test'),
      zero: anyNamed('zero'),
    )).thenAnswer((_) async => bar.future);

    when(mock.foo()).thenAnswer((_) async => foo.future);

    when(mock.baz()).thenReturn(baz.stream);
  }
}
