import 'package:blemulator_example/peripheral_details/bloc.dart';
import 'package:blemulator_example/peripheral_details/components/property_row.dart';
import 'package:blemulator_example/styles/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeripheralDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PeripheralDetailsBloc peripheralDetailsBloc =
        BlocProvider.of<PeripheralDetailsBloc>(context);

    return CustomScrollView(
      slivers: <Widget>[
        SliverSafeArea(
          top: false,
          sliver: SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverToBoxAdapter(
              child: _buildPeripheralProperties(peripheralDetailsBloc),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeripheralProperties(
      PeripheralDetailsBloc peripheralDetailsBloc) {
    return BlocBuilder<PeripheralDetailsBloc, PeripheralDetailsState>(
      builder: (context, state) {
        return PropertyRow(
          title: 'Identifier',
          titleIcon: Icons.perm_device_information,
          titleColor: Theme.of(context).primaryColor,
          value: state.peripheral.id,
          accessory: _buildConnectionButtons(context, peripheralDetailsBloc),
          accessoryPosition: PropertyRowAccessoryPosition.titleRow,
        );
      },
    );
  }

  Widget _buildConnectionButtons(
      BuildContext context, PeripheralDetailsBloc peripheralDetailsBloc) {
    return BlocBuilder<PeripheralDetailsBloc, PeripheralDetailsState>(
      builder: (context, state) {
        return FlatButton(
          child: Text(
            _connectionButtonText(state.peripheral.connectionState),
            style:
                CustomTextStyle.cardTitleButton.copyWith(color: Colors.white),
          ),
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: _onConnectionButtonPressed(
              state.peripheral.connectionState, peripheralDetailsBloc),
        );
      },
    );
  }

  String _connectionButtonText(PeripheralConnectionState connectionState) {
    switch (connectionState) {
      case PeripheralConnectionState.connected:
      case PeripheralConnectionState.connecting:
        return 'Disconnect';
      case PeripheralConnectionState.disconnected:
      case PeripheralConnectionState.disconnecting:
        return 'Connect';
      // default case is needed to avoid flutter analyzer warning
      // even though switch is in fact exhaustive
      default:
        return null;
    }
  }

  VoidCallback _onConnectionButtonPressed(
      PeripheralConnectionState connectionState,
      PeripheralDetailsBloc peripheralDetailsBloc) {
    switch (connectionState) {
      case PeripheralConnectionState.connected:
      case PeripheralConnectionState.connecting:
        return () => _disconnectFromPeripheral(peripheralDetailsBloc);
      case PeripheralConnectionState.disconnected:
      case PeripheralConnectionState.disconnecting:
        return () => _connectToPeripheral(peripheralDetailsBloc);
      // default case is needed to avoid flutter analyzer warning
      // even though switch is in fact exhaustive
      default:
        return null;
    }
  }

  void _connectToPeripheral(PeripheralDetailsBloc peripheralDetailsBloc) {
    peripheralDetailsBloc.add(ConnectToPeripheral());
  }

  void _disconnectFromPeripheral(PeripheralDetailsBloc peripheralDetailsBloc) {
    peripheralDetailsBloc.add(DisconnectFromPeripheral());
  }
}
