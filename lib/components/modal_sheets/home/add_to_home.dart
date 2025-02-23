import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/components/modal_sheets/dropdown_row.dart';
import 'package:homeasz/components/modal_sheets/modal_confirm_button.dart';
import 'package:homeasz/components/my_dropdownmenu.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/routine_model.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:provider/provider.dart';

class AddToHome extends StatelessWidget {
  AddToHome({super.key});
  Room? selectedRoom;
  RoutineCloudResponse? selectedRoutine;

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
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
              "Add to Home",
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
              alignment: const Alignment(-0.95, 0),
              child: Text(
                'Room',
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
            MyDropdownMenu(
                list: dataProvider.rooms,
                title: "Room",
                initialSelection: null,
                onSelected: (room) {
                  selectedRoom = room;
                }),
            const SizedBox(
              height: 20,
            ),
            ModalConfirmButton(
              buttonText: "Add",
              onPressed: () {
                dataProvider.updateHomeWindowFavouriteTiles(selectedRoom!);
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width - 66,
              child: Text(
                'Routine',
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
              height: 18,
            ),
            MyDropdownMenu(
                list: dataProvider.routines,
                title: "Routine",
                initialSelection: null,
                onSelected: (RoutineCloudResponse routine) {
                  selectedRoutine = routine;
                }),
            const SizedBox(
              height: 15,
            ),
            ModalConfirmButton(
                buttonText: "Add",
                onPressed: () {
                  dataProvider.updateHomeWindowFavouriteTiles(selectedRoutine!);
                  Navigator.pop(context);
                }),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
