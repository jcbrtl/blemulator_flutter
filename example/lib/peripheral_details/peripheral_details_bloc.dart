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
  StreamSubscription _peripheralConnectionStateSubscription;

  PeripheralDetailsBloc(this._bleAdapter, this._chosenPeripheral) {
    _peripheralConnectionStateSubscription = _bleAdapter
        .observePeripheralConnection(_chosenPeripheral.id)
        .listen((connectionState) {
      add(ConnectionStateUpdated(connectionState));
    });
    add(CheckConnectionState());
  }

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
    } else if (event is CheckConnectionState) {
      yield await _mapCheckConnectionState(event);
    } else if (event is ConnectionStateUpdated) {
      yield _mapConnectionStateUpdateToState(event);
    }
  }

  Future<PeripheralDetailsState> _mapConnectToPeripheralToState(
      ConnectToPeripheral event) async {
    try {
      await _bleAdapter.connectToPeripheral(state.peripheral.id);
      return PeripheralDetailsState(peripheral: state.peripheral);
    } on BleError catch (bleError) {
      return _mapBleErrorToState(bleError);
    }
  }

  Future<PeripheralDetailsState> _mapDisconnectFromPeripheralToState(
      DisconnectFromPeripheral event) async {
    try {
      await _bleAdapter.disconnectFromPeripheral(state.peripheral.id);
      return PeripheralDetailsState(peripheral: state.peripheral);
    } on BleError catch (bleError) {
      return _mapBleErrorToState(bleError);
    }
  }

  Future<PeripheralDetailsState> _mapCheckConnectionState(
      CheckConnectionState event) async {
    try {
      bool isConnected =
          await _bleAdapter.isPeripheralConnected(_chosenPeripheral.id);
      add(ConnectionStateUpdated(isConnected
          ? PeripheralConnectionState.connected
          : PeripheralConnectionState.disconnected));
      return PeripheralDetailsState(peripheral: state.peripheral);
    } on BleError catch (bleError) {
      return _mapBleErrorToState(bleError);
    }
  }

  PeripheralDetailsState _mapConnectionStateUpdateToState(
      ConnectionStateUpdated event) {
    return PeripheralDetailsState(
        peripheral:
            state.peripheral.copyWith(connectionState: event.connectionState));
  }

  PeripheralDetailsErrorState _mapBleErrorToState(BleError bleError) {
    return PeripheralDetailsErrorState(
      peripheral: state.peripheral,
      errorMessage:
          'BleError with code ${bleError.errorCode.value.toString()} has occured',
    );
  }

  @override
  Future<void> close() {
    _peripheralConnectionStateSubscription.cancel();
    return super.close();
  }
}
