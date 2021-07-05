// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MockOutletGenerator
// **************************************************************************

import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:my_generators/models.dart';
import 'input.mocks.dart';

import 'input.dart';
import 'package:example_usage/model.dart';
import 'package:mockito/annotations.dart';
import 'dart:core';

class Outlets {
  final someService = OutletSomeService();
  final someController = OutletSomeController();
  List<BaseOutlet> get all => [
        someService,
        someController,
      ];
  void resetMocks() {
    all.forEach((outlet) {
      clearInteractions(outlet.mock);
    });
  }
}

class OutletSomeService extends BaseOutlet {
  final bar = StubFuture<int>();
  final foo = StubFuture<Dog>();
  final MockSomeService mock =
      GetIt.instance.get<SomeService>() as MockSomeService;

  OutletSomeService() {
    bar.setReset(() {
      when(mock.bar(
        any,
      )).thenAnswer((_) async => bar.stub.future);
    });

    foo.setReset(() {
      when(mock.foo(
        any,
        any,
      )).thenAnswer((_) async => foo.stub.future);
    });

    resetAll();
  }
  void resetAll() {
    bar.reset();
    foo.reset();
  }
}

class OutletSomeController extends BaseOutlet {
  final bar = StubFuture<int>();
  final foo = StubFuture<int>();
  final baz = StubStream<int>();
  final MockSomeController mock =
      GetIt.instance.get<SomeController>() as MockSomeController;

  OutletSomeController() {
    bar.setReset(() {
      when(mock.bar(
        any,
        glass: anyNamed('glass'),
        test: anyNamed('test'),
        zero: anyNamed('zero'),
      )).thenAnswer((_) async => bar.stub.future);
    });

    foo.setReset(() {
      when(mock.foo()).thenAnswer((_) async => foo.stub.future);
    });

    baz.setReset(() {
      when(mock.baz()).thenAnswer((_) => baz.stub.stream);
    });

    resetAll();
  }
  void resetAll() {
    bar.reset();
    foo.reset();
    baz.reset();
  }
}
