import 'package:flutter/material.dart';

class RoomTile extends StatefulWidget {
  const RoomTile(
      {super.key,
      required this.index,
      required this.roomName,
      required this.roomImage});


  final int index;
  final String roomName;
  final String roomImage;

  @override
  State<RoomTile> createState() => _RoomTileState();
}

class _RoomTileState extends State<RoomTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xA8D9D9D9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Image.asset(
                'lib/assets/rooms/${widget.roomImage}.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 10),
              const Text("Hello")
            ],
          ),
        ],
      ),
    );
  }
}
