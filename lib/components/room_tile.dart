import 'package:flutter/material.dart';
import 'package:homeasz/components/base_tile.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/pages/room_page.dart';
import 'package:homeasz/utils/image_paths.dart';

class RoomTile extends StatelessWidget {
  final Room room;

  const RoomTile({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTile(
      tileName: room.name,
      tileType: room.type,
      initialState: false,
      imagePath: roomImagePath,
      onTap: () {
        // Logic for navigating to room page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomPage(
              roomId: room.id,
              roomName: room.name,
              roomType: room.type,
            ),
          ),
        );
      },
      onLongPress: () {
        // Additional long press action for room tile, if any
      },
    );
  }
}
