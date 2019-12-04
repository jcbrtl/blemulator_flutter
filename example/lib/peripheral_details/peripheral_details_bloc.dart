import 'dart:async';
import 'package:blemulator_example/adapter/ble_adapter.dart';
import 'package:blemulator_example/model/ble_peripheral.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import './bloc.dart';

class PeripheralDetailsBloc
    extends Bloc<PeripheralDetailsEvent, PeripheralDetailsState> {
  BleAdapter _bleAdapter;
  final BlePeripheral _chosenPeripheral;

  PeripheralDetailsBloc(this._bleAdapter, this._chosenPeripheral);

  @override
  PeripheralDetailsState get initialState =>
      PeripheralDetailsState(peripheral: _chosenPeripheral);

  @override
  Stream<PeripheralDetailsState> mapEventToState(
    PeripheralDetailsEvent event,
  ) async* {
    if (event is ConnectToPeripheral) {
      yield await _mapConnectToPeripheralToState(event);
    } else if (event is DisconnectFromPeripheral) {
      yield await _mapDisconnectFromPeripheralToState(event);
    }
  }

  Future<PeripheralDetailsState> _mapConnectToPeripheralToState(
      ConnectToPeripheral event) async {
    try {
      await _bleAdapter.connectToPeripheral(state.peripheral.id);
      final peripheral = state.peripheral
          .copyWith(connectionState: PeripheralConnectionState.connected);
      return PeripheralDetailsState(peripheral: peripheral);
    } on Error {
      // TODO: - Error handling
    }
  }

  Future<PeripheralDetailsState> _mapDisconnectFromPeripheralToState(
      DisconnectFromPeripheral event) async {
    try {
      await _bleAdapter.disconnectFromPeripheral(state.peripheral.id);
      final peripheral = state.peripheral
          .copyWith(connectionState: PeripheralConnectionState.disconnected);
      return PeripheralDetailsState(peripheral: peripheral);
    } on Error {
      // TODO: - Error handling
    }
  }
}
