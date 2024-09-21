import 'package:flutter/material.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/pages/room_page.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({
    super.key,
    required this.index,
    required this.roomName,
  });

  final int index;
  final String roomName;
  // get a random color

  @override
  Widget build(BuildContext context) {
    Color random =
        Color((index * 0x12345678 * (10 + index) + 5235529935) & 0xFFFFFFFF);
    return Card(
        color: random,
        child: ListTile(
            // center the title
            title: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 8),
              child: Center(
                child: Text(
                  roomName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RoomPage(
                            roomIndex: index,
                          )));
            }));
  }
}
