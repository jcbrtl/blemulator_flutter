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

    return MultiBlocListener(
      listeners: [
        BlocListener<PeripheralDetailsBloc, PeripheralDetailsState>(
          condition: (previousState, state) {
            return previousState.peripheral.connectionState !=
                state.peripheral.connectionState;
          },
          listener: (context, state) {
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(_connectionStateDescription(
                    state.peripheral.connectionState)),
              ),
            );
          },
        ),
        BlocListener<PeripheralDetailsBloc, PeripheralDetailsState>(
          condition: (_, state) {
            return (state is PeripheralDetailsErrorState);
          },
          listener: (context, state) {
            showDialog(
              context: context,
              builder: (context) {
                final errorState = state as PeripheralDetailsErrorState;
                return SimpleDialog(
                  title: Text(errorState.errorMessage),
                  children: <Widget>[
                    SimpleDialogOption(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
          },
        ),
      ],
      child: CustomScrollView(
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
      ),
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
          titleAccessory:
              _buildConnectionButton(context, peripheralDetailsBloc),
        );
      },
    );
  }

  Widget _buildConnectionButton(
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

  String _connectionStateDescription(
      PeripheralConnectionState connectionState) {
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

  void _connectToPeripheral(PeripheralDetailsBloc peripheralDetailsBloc) {
    peripheralDetailsBloc.add(ConnectToPeripheral());
  }

  void _disconnectFromPeripheral(PeripheralDetailsBloc peripheralDetailsBloc) {
    peripheralDetailsBloc.add(DisconnectFromPeripheral());
  }
}
