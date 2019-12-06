import 'dart:async';

import 'package:blemulator_example/model/ble_peripheral.dart';
import 'package:blemulator_example/peripheral_details/bloc.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/mocks.dart';
import '../mock/sample_ble_peripheral.dart';

void main() {
  PeripheralDetailsBloc peripheralDetailsBloc;
  MockBleAdapter bleAdapter;
  BlePeripheral peripheral;
  StreamController<PeripheralConnectionState>
      peripheralConnectionStateStreamController;

  setUp(() {
    bleAdapter = MockBleAdapter();
    peripheral = SampleBlePeripheral();
    peripheralDetailsBloc = PeripheralDetailsBloc(bleAdapter, peripheral);
    peripheralConnectionStateStreamController = StreamController();

  });

  void receiveEvent(PeripheralDetailsEvent event) {
    peripheralDetailsBloc.add(event);
  }

  void firePeripheralConnectionStateFromAdapter(
      PeripheralConnectionState connectionState) {
    peripheralConnectionStateStreamController.sink.add(connectionState);
  }

  tearDown(() {
    peripheralDetailsBloc.close();
    bleAdapter = null;
    peripheralConnectionStateStreamController.close();
  });

  test('initial state contains peripheral provided in the constructor', () {
    expect(peripheralDetailsBloc.initialState.peripheral, peripheral);
  });

  group('receiving ConnectToPeripheral event', () {
    test('emits PeripheralDetailsState if no BleError was thrown', () {});

    test('emits PeripheralDetailsErrorState if BleError was thrown', () {});
  });

  group('receiving DisconnectFromPeripheral event', () {
    test('emits PeripheralDetailsState if no BleError was thrown', () {});

    test('emits PeripheralDetailsErrorState if BleError was thrown', () {});
  });

  group('receiving CheckConnectionState', () {
    test('emits PeripheralDetailsState if no BleError was thrown', () {});

    test('emits PeripheralDetailsErrorState if BleError was thrown', () {});
  });

  test(
      'receiving ConnectionStateUpdate event emits PeripheralDetailsState with '
      'updated PeripheralConnectionState',
      () {});
}
