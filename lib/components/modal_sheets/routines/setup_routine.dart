import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/components/modal_sheets/routines/device_routine_row.dart';
import 'package:homeasz/components/modal_sheets/dropdown.dart';
import 'package:homeasz/components/modal_sheets/modal_confirm_button.dart';
import 'package:homeasz/components/modal_sheets/routines/repeat_schedule_input.dart';
import 'package:homeasz/components/text_input.dart';

class SetupRoutine extends StatelessWidget{
  SetupRoutine({super.key});
  final TextEditingController routineName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: 25, right: 25,bottom: MediaQuery.of(context).viewInsets.bottom),
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
              "Setup Routine",
              style: GoogleFonts.poppins(
                color: const Color(0xFF000000),
                fontSize: 22,
                height: 0.05,
                letterSpacing: -0.66,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Align(
              alignment: const Alignment(-0.95, 0),
              child: Text(
                'Routine Name',
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
            SizedBox(width: 313, child: TextInput(input: routineName)),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: const Alignment(-0.95, 0),
              child: Text(
                'Repeat',
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
            const SizedBox(height: 20,),
            const RepeatScheduleInput(),
            const SizedBox(height: 30,),
            Align(
              alignment: const Alignment(-0.95, 0),
              child: Text(
                'Devices',
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
            const SizedBox(height: 20,),
            const DeviceRoutineRow(),
            const SizedBox(height: 20,),
            ModalConfirmButton(buttonText: "Confirm", onPressed: (){},),
            const SizedBox(height: 80,)

          ],
        ),
      ),
    );
  }
}