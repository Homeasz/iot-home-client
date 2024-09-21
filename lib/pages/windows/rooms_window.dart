import 'package:flutter/material.dart';
import 'package:homeasz/components/room_tile.dart';

import 'package:homeasz/components/switch_tile.dart';

class RoomsWindow extends StatefulWidget {
  const RoomsWindow({super.key});

  @override
  State<RoomsWindow> createState() => _RoomsWindowState();
}

class _RoomsWindowState extends State<RoomsWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(color: Colors.black, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 30, left: 5, right: 5),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return RoomTile(index: index, roomName: "Balcony",roomImage: "balconyfalse",);
              }),
            ),
          ],
        ));
  }
}
