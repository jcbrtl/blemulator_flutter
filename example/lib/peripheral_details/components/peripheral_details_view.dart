import 'package:blemulator_example/peripheral_details/bloc.dart';
import 'package:blemulator_example/peripheral_details/components/property_row.dart';
import 'package:flutter/material.dart';
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
          accessory: BlocBuilder<PeripheralDetailsBloc, PeripheralDetailsState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(state.peripheral.isConnected
                    ? Icons.bluetooth_searching
                    : Icons.bluetooth_disabled),
                tooltip: state.peripheral.isConnected
                    ? 'Disable Bluetooth scanning'
                    : 'Enable Bluetooth scanning',
                onPressed: () => state.peripheral.isConnected
                    ? _connectToPeripheral(peripheralDetailsBloc)
                    : _disconnectFromPeripheral(peripheralDetailsBloc),
              );
            },
          ),
        );
      },
    );
  }

  void _connectToPeripheral(PeripheralDetailsBloc peripheralDetailsBloc) {}

  void _disconnectFromPeripheral(PeripheralDetailsBloc peripheralDetailsBloc) {}
}
