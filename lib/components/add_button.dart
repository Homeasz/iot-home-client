import 'package:flutter/material.dart';
import 'package:homeasz/components/modal_sheets/create_room/add_room_icons_grid.dart';
import 'package:homeasz/components/modal_sheets/create_room/add_room.dart';
import 'package:homeasz/components/modal_sheets/home/add_to_home.dart';
import 'package:homeasz/components/modal_sheets/routines/setup_routine.dart';
import 'package:homeasz/utils/constants.dart';

class AddButton extends StatefulWidget {
  final int window;
  final dynamic arguments; //passing any arguments to Navigator.pushNamed

  const AddButton({super.key, required this.window, this.arguments});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> actions = [
      AddToHome(),
      AddRoom(),
      // SetupRoutine(),
      // const AddAppliance(),
    ];

    return InkWell(
        splashColor: const Color(0xFFB1E8FF),
        child: Container(
          height: 58,
          width: 58,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey, blurRadius: 2, offset: Offset(2, 2))
              ],
              borderRadius: BorderRadius.circular(50),
              color: const Color(0xFFB1E8FF)),
          child: Image.asset(
            'lib/assets/add.png',
          ),
        ),
        onTap: () {
          if (widget.window == addDeviceWindow) {
            // go to add esp page
            Navigator.pushNamed(context, '/add_esp',
                arguments: widget.arguments);
          } else if (widget.window == routinesWindow) {
            // go to add appliance page
            Navigator.pushNamed(context, '/editRoutine');
          } else {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                useSafeArea: true,
                backgroundColor: const Color(0xFFE7F8FF),
                builder: (context) {
                  return SingleChildScrollView(
                      child: Wrap(children: [actions[widget.window]]));
                }).whenComplete(() {
              AddRoomIconsGrid.activeState = -1;
            });
          }
        });
  }
}
