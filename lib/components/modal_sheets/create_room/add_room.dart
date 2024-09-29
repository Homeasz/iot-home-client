import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/components/modal_sheets/modal_confirm_button.dart';
import 'package:homeasz/components/modal_sheets/create_room/add_room_icons_grid.dart';
import 'package:homeasz/components/text_input.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/constants.dart';
import 'package:provider/provider.dart';

class AddRoom extends StatelessWidget {
  AddRoom({super.key});
  final TextEditingController _textEditingController = TextEditingController();

  void _addRoomIcon(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    int iconIndex = AddRoomIconsGrid.activeState;
    dataProvider.addRoom(_textEditingController.text, roomNames[iconIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 18,
            ),
            Container(
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xFFE3E3E3)),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Add Room",
              style: GoogleFonts.poppins(
                color: const Color(0xFF000000),
                fontSize: 22,
                height: 0.05,
                letterSpacing: -0.66,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Align(
              alignment: const Alignment(-0.9, 0),
              child: Text(
                'Room Name',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 0.06,
                  letterSpacing: -0.54,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextInput(
              input: _textEditingController,
              hintText: "Enter Room Name",
            ),
            const SizedBox(
              height: 20,
            ),
            AddRoomIconsGrid(),
            ModalConfirmButton(
              buttonText: "Add",
              onPressed: () {
                _addRoomIcon(context);
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
