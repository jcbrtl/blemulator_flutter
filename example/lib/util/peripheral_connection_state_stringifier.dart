import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class PeripheralConnectionStateStringifier {
  static String description(PeripheralConnectionState connectionState) {
    switch (connectionState) {
      case PeripheralConnectionState.connecting:
        return 'Connecting to peripheral';
      case PeripheralConnectionState.connected:
        return 'Peripheral connected';
      case PeripheralConnectionState.disconnecting:
        return 'Disconnecting from peripheral';
      case PeripheralConnectionState.disconnected:
        return 'Peripheral disconnected';
      default:
        return 'Unknown';
    }
  }
}
