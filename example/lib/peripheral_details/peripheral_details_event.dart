import 'package:equatable/equatable.dart';

abstract class PeripheralDetailsEvent extends Equatable {
  const PeripheralDetailsEvent();
}

class ConnectToPeripheral extends PeripheralDetailsEvent {
  @override
  List<Object> get props => [];
}

class DisconnectFromPeripheral extends PeripheralDetailsEvent {
  @override
  List<Object> get props => null;

}
