import 'package:equatable/equatable.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

abstract class PeripheralDetailsEvent extends Equatable {
  const PeripheralDetailsEvent();
}

class ConnectToPeripheral extends PeripheralDetailsEvent {
  @override
  List<Object> get props => [];
}

class DisconnectFromPeripheral extends PeripheralDetailsEvent {
  @override
  List<Object> get props => [];
}

class CheckConnectionState extends PeripheralDetailsEvent {
  @override
  List<Object> get props => [];
}

class ConnectionStateUpdated extends PeripheralDetailsEvent {
  final PeripheralConnectionState connectionState;

  const ConnectionStateUpdated(this.connectionState);

  @override
  List<Object> get props => [connectionState];
}
