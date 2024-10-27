import 'package:flutter/material.dart';
import 'package:homeasz/components/big_tile.dart';

// extend from big tile

class RoomTile extends BigTile {
  const RoomTile({
    Key? key,
    required int id,
    required int index,
    required String tileName,
    required String tileType,
    bool appliance = false,
    String roomName = 'Living Room',
    bool state = false,
  }) : super(
          key: key,
          id: id,
          index: index,
          tileName: tileName,
          tileType: tileType,
          appliance: appliance,
          roomName: roomName,
          state: state,
        );
}
