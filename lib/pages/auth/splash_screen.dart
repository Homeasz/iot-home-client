import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 83,
              child: Image.asset('lib/assets/Homeasz_logo.png'),
            ),
            Text(
              "Homeasz",
              style: GoogleFonts.alice(
                color: Colors.black,
                fontSize: 45,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        )
      )
    );
  }
}
