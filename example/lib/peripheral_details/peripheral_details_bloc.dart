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
    _updatePeripheralConnectionState();
    _peripheralConnectionStateSubscription = _bleAdapter
        .observePeripheralConnection(_chosenPeripheral.id)
        .listen((connectionState) {
      add(ConnectionStateUpdated(connectionState));
    });
  }

  void _updatePeripheralConnectionState() async {
    bool isConnected =
        await _bleAdapter.isPeripheralConnected(_chosenPeripheral.id);
    add(ConnectionStateUpdated(isConnected
        ? PeripheralConnectionState.connected
        : PeripheralConnectionState.disconnected));
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
    } else if (event is ConnectionStateUpdated) {
      yield _mapConnectionStateUpdateToState(event);
    }
  }

  Future<PeripheralDetailsState> _mapConnectToPeripheralToState(
      ConnectToPeripheral event) async {
    try {
      await _bleAdapter.connectToPeripheral(state.peripheral.id);
      return PeripheralDetailsState(peripheral: state.peripheral);
    } on Error {
      // TODO: - Error handling
    }
  }

  Future<PeripheralDetailsState> _mapDisconnectFromPeripheralToState(
      DisconnectFromPeripheral event) async {
    try {
      await _bleAdapter.disconnectFromPeripheral(state.peripheral.id);
      return PeripheralDetailsState(peripheral: state.peripheral);
    } on Error {
      // TODO: - Error handling
    }
  }

  PeripheralDetailsState _mapConnectionStateUpdateToState(
      ConnectionStateUpdated event) {
    return PeripheralDetailsState(
        peripheral:
            state.peripheral.copyWith(connectionState: event.connectionState));
  }

  @override
  Future<void> close() {
    _peripheralConnectionStateSubscription.cancel();
    return super.close();
  }
}
