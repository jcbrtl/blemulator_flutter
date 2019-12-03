import 'package:equatable/equatable.dart';

class BlePeripheral extends Equatable {
  final String name;
  final String id;
  final int rssi;
  final bool isConnected;
  final BlePeripheralCategory category;

  BlePeripheral(this.name, this.id, this.rssi, this.isConnected, this.category);

  BlePeripheral copyWith(
      {String name, String, id, int rssi, bool isConnected, BlePeripheralCategory category}) {
    return BlePeripheral(
      name ?? this.name,
      id ?? this.id,
      rssi ?? this.rssi,
      isConnected ?? this.isConnected,
      category ?? this.category,
    );
  }

  @override
  List<Object> get props => [name, id, rssi, isConnected];
}

enum BlePeripheralCategory { sensorTag, other }

class BlePeripheralCategoryResolver {
  static const String sensorTag = 'SensorTag';

  static BlePeripheralCategory categoryForName(String blePeripheralName) {
    return _isSensorTag(blePeripheralName)
        ? BlePeripheralCategory.sensorTag
        : BlePeripheralCategory.other;
  }

  static bool _isSensorTag(String blePeripheralName) {
    return blePeripheralName == sensorTag;
  }
}
