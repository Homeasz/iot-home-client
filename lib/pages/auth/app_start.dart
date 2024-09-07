import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/pages/auth/auth_page.dart';
import 'dart:async';

class AppStart extends StatelessWidget {
//   const AppStart({super.key});

//   @override
//   State<AppStart> createState() => _AppStartState();
// }

// class _AppStartState extends State<AppStart> {
//   bool _displaySplash = true;

//   @override
//   void initState() {
//     super.initState();
//     // Set the widget to be hidden after 1 second
//     Timer(const Duration(seconds: 1), () {
//       setState(() {
//         _displaySplash = false;
//       });
//     });
//   }

  @override
  Widget build(BuildContext context) {
    // if (_displaySplash) {
      return Scaffold(
          backgroundColor: const Color(0xFF87CEEB),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 83,child:  Image.asset('lib/assets/Homeasz_logo.png'),),
              Text(
                "Homeasz",
                style: GoogleFonts.alice(
                  color: Colors.black,
                  fontSize: 45,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          )));
    // } else {
    //   return const AuthPage();
    // }
  }
}
