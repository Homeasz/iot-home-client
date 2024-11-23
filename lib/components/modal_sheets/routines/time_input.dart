import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';

class TimeInput extends StatefulWidget {
  const TimeInput({super.key});

  @override
  State<StatefulWidget> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  int routineHour = 1;
  int routineMin = 1;
  int amPm = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 25,
            child: NumberPicker(
                textStyle: GoogleFonts.poppins(
                    height: 0.06, letterSpacing: -0.54, fontSize: 18),
                infiniteLoop: true,
                minValue: 1,
                maxValue: 12,
                value: routineHour,
                onChanged: (value) => {setState(() => routineHour = value)})),
        Text(
          ':',
          style: GoogleFonts.poppins(fontSize: 18),
        ),
        SizedBox(
            width: 30,
            child: NumberPicker(
                textStyle: GoogleFonts.poppins(
                    height: 0.06, letterSpacing: -0.54, fontSize: 18),
                zeroPad: true,
                infiniteLoop: true,
                minValue: 00,
                maxValue: 59,
                value: routineMin,
                onChanged: (value) => {setState(() => routineMin = value)})),
        SizedBox(
          width: 40,
          child: NumberPicker(
              textStyle: GoogleFonts.poppins(
                  height: 0.06, letterSpacing: -0.54, fontSize: 18),
              infiniteLoop: true,
              minValue: 0,
              maxValue: 1,
              value: amPm,
              onChanged: (value) => setState(() => amPm = value),
              textMapper: (value) => value == "0" ? "am" : "pm"),
        ),
      ],
    );
  }
}
