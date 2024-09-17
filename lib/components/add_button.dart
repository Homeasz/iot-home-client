import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/components/add_room_icons_grid.dart';
import 'package:homeasz/components/modal_sheets/add_room.dart';
import 'package:homeasz/components/modal_sheets/add_to_home.dart';
import 'package:homeasz/components/modal_sheets/setup_routine.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: const Color(0xFFB1E8FF),
        child: Container(
          height: 58,
          width: 58,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 2, offset: Offset(2, 2))
          ], borderRadius: BorderRadius.circular(50), color: Color(0xFFB1E8FF)),
          child: Image.asset(
            'lib/assets/add.png',
          ),
        ),
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              useSafeArea: true,
              backgroundColor: const Color(0xFFE7F8FF),
              builder: (context) {
                return SingleChildScrollView(
                    child: Wrap(children: [SetupRoutine()]));
              }).whenComplete(() {
            AddRoomIconsGrid.activeState = -1;
          });
        });
  }
}
