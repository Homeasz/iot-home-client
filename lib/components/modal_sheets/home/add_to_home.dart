import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/components/modal_sheets/dropdown.dart';
import 'package:homeasz/components/modal_sheets/dropdown_row.dart';
import 'package:homeasz/components/modal_sheets/modal_confirm_button.dart';

class AddToHome extends StatelessWidget {
  const AddToHome({super.key});

  @override
  Widget build(BuildContext context) {
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
            const DropdownRow(title: "Rooms", hint: "Select Rooms",),
            const SizedBox(
              height: 20,
            ),
            ModalConfirmButton(buttonText: "Add", onPressed: (){},),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 66,
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
            const DropdownRow(title: "Routine",hint: "Select routine"),
            const SizedBox(
              height: 15,
            ),
            ModalConfirmButton(buttonText: "Add", onPressed: (){}),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
