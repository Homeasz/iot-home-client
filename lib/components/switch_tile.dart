import 'package:flutter/material.dart';
import 'package:homeasz/components/modal_sheets/edit_appliance.dart';
import 'package:homeasz/components/base_tile.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/image_paths.dart';
import 'package:provider/provider.dart';


class SwitchTile extends StatelessWidget {
  final PowerSwitch powerSwitch;
  final String roomName;

  const SwitchTile({
    super.key,
    required this.powerSwitch,
    required this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTile(
      tileName: powerSwitch.name,
      tileType: powerSwitch.type,
      initialState: powerSwitch.state,
      imagePath: applianceImagePath,
      onTap: () {
        // Logic for toggling switch
      },
      onLongPress: () {
        // Logic for showing appliance modal
        showDialog(
        context: context,
        useSafeArea: true,
        // backgroundColor: const Color(0xFFE7F8FF),
        builder: (context) {
          return Dialog(
            backgroundColor: const Color(0xFFE7F8FF),
            child: EditAppliance(
              applianceName: powerSwitch.name,
              applianceType: powerSwitch.type,
              roomName: roomName,
              applianceId: powerSwitch.id,
            ),
          );
        });
      },
      onPowerTap: () {
        // Logic for toggling power state
        final dataProvider = Provider.of<DataProvider>(context, listen: false);
        dataProvider.toggleSwitch(powerSwitch.id, powerSwitch.state);
      },
    );
  }
}


