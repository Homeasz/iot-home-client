import 'package:flutter/material.dart';
import 'package:homeasz/components/modal_sheets/create_room/room_icon.dart';
import 'package:homeasz/utils/constants.dart';

typedef MyBuilder = void Function(
    BuildContext context, void Function() methodFromChild);

class AddRoomIconsGrid extends StatelessWidget {
  AddRoomIconsGrid({super.key});
  late void Function() toggleRoomIcon;
  static int activeState = -1;
  

  @override
  Widget build(BuildContext context) {
    List<void Function()> RoomIconToggleFn = [];
    
    return Column(children: [
      SizedBox(
        width: 211,
        height: 470,
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: List.generate(roomNames.length, (index) {
            return GestureDetector(
              onTap: () {
                if (index == activeState) {
                  activeState = -1;
                } else if (index != activeState) {
                  if (activeState != -1) {
                    RoomIconToggleFn[activeState].call();
                  }
                  activeState = index;
                }
                RoomIconToggleFn[index].call();
              },
              child: SizedBox(
                width: 83,
                height: 83,
                child: RoomIcon(
                    roomType: roomNames[index],
                    builder: (context, toggle) {
                      RoomIconToggleFn.add(toggle);
                    }),
              ),
            );
          }),
        ),
      ),
      
    ]);
  }
}
