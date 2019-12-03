import 'dart:async';
import 'package:blemulator_example/adapter/ble_adapter.dart';
import 'package:blemulator_example/model/ble_peripheral.dart';
import 'package:bloc/bloc.dart';
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
      yield _mapConnectToPeripheralToState(event);
    } else if (event is DisconnectFromPeripheral) {
      yield _mapDisconnectFromPeripheralToState(event);
    }
  }

  PeripheralDetailsState _mapConnectToPeripheralToState(
      ConnectToPeripheral event) {
    // TODO: call bleAdapter to do the logic
    final peripheral = BlePeripheral(state.peripheral.name, state.peripheral.id,
        state.peripheral.rssi, !state.peripheral.isConnected);
    return PeripheralDetailsState(peripheral: peripheral);
  }

  PeripheralDetailsState _mapDisconnectFromPeripheralToState(
      DisconnectFromPeripheral event) {
    // TODO: call bleAdapter to do the logic
    final peripheral = BlePeripheral(state.peripheral.name, state.peripheral.id,
        state.peripheral.rssi, !state.peripheral.isConnected);
    return PeripheralDetailsState(peripheral: peripheral);
  }
}
