import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/components/dropdown.dart';
import 'package:homeasz/components/mini_dropdown.dart';

class DeviceRoutineRow extends StatefulWidget{
  const DeviceRoutineRow({super.key});

  @override
  State<StatefulWidget> createState() => _DeviceRoutineRowState();
}

class _DeviceRoutineRowState extends State<DeviceRoutineRow> {
 @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 313,
        height: 52,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(1, 1),
              ),
              const BoxShadow(
                  color: Color(0xffffffff), offset: Offset(-3, -3), blurRadius: 0)
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                'BedRoom\'s Light',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 0.06,
                  letterSpacing: -0.54,
                ),
              ),
              
              SizedBox( width: 133, height: 52, child: MiniDropdown()),
              ],
              
            )
            ),
    );
  } 
}