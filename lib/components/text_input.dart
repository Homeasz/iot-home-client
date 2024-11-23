import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInput extends StatelessWidget {
  const TextInput({super.key, required this.input, required this.hintText});
  final TextEditingController input;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    //TODO: create an interface that adds the shadow
    return Container(
      // width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.shade400,
        //     spreadRadius: 1,
        //     blurRadius: 2,
        //     offset: const Offset(0.1, 0.1),
        //   ),
        //   const BoxShadow(
        //       color: Color(0xffffffff), offset: Offset(-3, -3), blurRadius: 0)
        // ]
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 2, 17, 10),
        child: TextField(
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            // height: 0.01,
            letterSpacing: -0.54,
          ),
          // showCursor: true,
          enableInteractiveSelection: true,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          controller: input,
          cursorHeight: 30,
          // onclicking doesnt open keyboard

          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                // height: 0.01,
                letterSpacing: -0.54,
              ),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFC2BCBC))),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Color(0xFFC2BCBC))),
              border: InputBorder.none),
        ),
      ),
    );
  }
}
