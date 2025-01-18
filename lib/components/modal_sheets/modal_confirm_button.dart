import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModalConfirmButton extends StatelessWidget {
  const ModalConfirmButton(
      {super.key, required this.buttonText, required this.onPressed});
  final String buttonText;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.85, 1),
      child: SizedBox(
        height: 36,
        child: ElevatedButton(
            style: const ButtonStyle(
                elevation: WidgetStatePropertyAll(4),
                backgroundColor: WidgetStatePropertyAll(Colors.white)),
            onPressed: onPressed,
            child: Text(buttonText,
                style: GoogleFonts.poppins(
                  height: 2,
                  color: Colors.black,
                  letterSpacing: -0.54,
                ))),
      ),
    );
  }
}
