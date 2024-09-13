import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInput extends StatelessWidget {
  const TextInput({super.key, required this.input});
  final TextEditingController input;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 273,
      height: 52,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0.1, 0.1),
            ),
            const BoxShadow(
                color: Color(0xffffffff), offset: Offset(-3, -3), blurRadius: 0)
          ]),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 2, 17, 10),
        child: TextField(
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            height: 0.06,
            letterSpacing: -0.54,
          ),
          showCursor: false,
          controller: input,
          decoration: InputDecoration(
              hintText: "Enter room name",
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                height: 0.06,
                letterSpacing: -0.54,
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Color(0xFFC2BCBC))),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Color(0xFFC2BCBC))),
              border: InputBorder.none),
        ),
      ),
    );
  }
}
