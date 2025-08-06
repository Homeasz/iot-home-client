import 'package:flutter/material.dart';
import 'package:homeasz/components/room_tile.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:provider/provider.dart';

class RoomsWindow extends StatefulWidget {
  const RoomsWindow({super.key});

  @override
  State<RoomsWindow> createState() => _RoomsWindowState();
}

class _RoomsWindowState extends State<RoomsWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.sizeOf(context).height - 100,
        width: MediaQuery.sizeOf(context).width,
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

        // detected pull down gesture

        child: Column(
          children: [
            Expanded(
              child: Consumer<DataProvider>(
                builder: (context, dataProvider, child) => GridView.builder(
                    padding: const EdgeInsets.only(
                        top: 20, left: 5, right: 5, bottom: 40),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: dataProvider.rooms.length,
                    itemBuilder: (context, index) {
                      final room = dataProvider.rooms[index];
                      // return BigTile(
                      //     id: room.id,
                      //     index: index,
                      //     tileName: room.name,
                      //     tileType: room.type
                      //   );
                      return RoomTile(room: room);
                    }),
              ),
            ),
          ],
        ));
  }
}
