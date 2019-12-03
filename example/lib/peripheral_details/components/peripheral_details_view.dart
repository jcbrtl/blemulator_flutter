import 'package:blemulator_example/peripheral_details/bloc.dart';
import 'package:blemulator_example/peripheral_details/components/property_row.dart';
import 'package:blemulator_example/styles/custom_text_style.dart';
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
          accessory: _buildConnectionButtons(context, peripheralDetailsBloc),
          accessoryPosition: PropertyRowAccessoryPosition.titleRow,
        );
      },
    );
  }

  Widget _buildConnectionButtons(BuildContext context, PeripheralDetailsBloc peripheralDetailsBloc) {
    return BlocBuilder<PeripheralDetailsBloc, PeripheralDetailsState>(
      builder: (context, state) {
        return FlatButton(
          child: Text(
            state.peripheral.isConnected ? 'Disconnect' : 'Connect',
            style:
            CustomTextStyle.cardTitleButton.copyWith(color: Colors.white),
          ),
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () => state.peripheral.isConnected
              ? _disconnectFromPeripheral(peripheralDetailsBloc)
              : _connectToPeripheral(peripheralDetailsBloc),
        );
      },
    );
  }

  void _connectToPeripheral(PeripheralDetailsBloc peripheralDetailsBloc) {
    peripheralDetailsBloc.add(ConnectToPeripheral());
  }

  void _disconnectFromPeripheral(PeripheralDetailsBloc peripheralDetailsBloc) {
    peripheralDetailsBloc.add(DisconnectFromPeripheral());
  }
}
