import 'dart:async';

import 'package:blemulator_example/model/ble_peripheral.dart';
import 'package:blemulator_example/peripheral_details/bloc.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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
    peripheralConnectionStateStreamController = StreamController();

    when(bleAdapter.isPeripheralConnected(peripheral.id)).thenAnswer((_) =>
        Future.value(
            peripheral.connectionState == PeripheralConnectionState.connected));
    when(bleAdapter.observePeripheralConnection(peripheral.id))
        .thenAnswer((_) => peripheralConnectionStateStreamController.stream);

    peripheralDetailsBloc = PeripheralDetailsBloc(bleAdapter, peripheral);
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

//  test('initial state contains peripheral provided in the constructor', () {
//    expect(peripheralDetailsBloc.initialState.peripheral, peripheral);
//  });
//
//  group('receiving ConnectToPeripheral event', () {
//    test('emits PeripheralDetailsState if no BleError was thrown', () {});
//
//    test('emits PeripheralDetailsErrorState if BleError was thrown', () {});
//  });
//
//  group('receiving DisconnectFromPeripheral event', () {
//    test('emits PeripheralDetailsState if no BleError was thrown', () {});
//
//    test('emits PeripheralDetailsErrorState if BleError was thrown', () {});
//  });
//
//  group('receiving CheckConnectionState', () {
//    test('emits PeripheralDetailsState if no BleError was thrown', () {});
//
//    test('emits PeripheralDetailsErrorState if BleError was thrown', () {});
//  });

  test(
      'receiving ConnectionStateUpdate event emits PeripheralDetailsState with '
      'updated PeripheralConnectionState', () {
    // given
    final incomingConnectionState = PeripheralConnectionState.connected;

    // when
    firePeripheralConnectionStateFromAdapter(incomingConnectionState);

    // then
    final expectedResponse = [
      PeripheralDetailsState(
          peripheral:
              peripheral.copyWith(connectionState: incomingConnectionState)),
    ];
    expectLater(peripheralDetailsBloc, emitsAnyOf(expectedResponse));
  });
}
