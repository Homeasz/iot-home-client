import 'package:flutter/material.dart';
import 'dart:math';
import 'package:homeasz/utils/image_paths.dart';
import 'package:path/path.dart';

void loading(context){

  List<String> loadingTexts = ["Calibrating\nyour space...", "Automating\nyour comfort...", "Harmonizing\nthe lights...", "Bonding\nwith home...", "Almost there..."];
  Random random = Random();
    showDialog(
      context: context,
      builder: (context) => Container(
        width: 100,
        child: Dialog(
          insetPadding: EdgeInsets.fromLTRB(100, 0, 100, 0),
          elevation: 20.0,
          backgroundColor: Color.fromARGB(255, 135, 207, 235),
            shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              const SizedBox(height: 20,),
              SizedBox(height: 80, width: 80, child: Image.asset(homeaszLoading)),//CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF87CEEB)),strokeWidth: 6.0,), //TODO: replace with logo animation
              const SizedBox(height: 20,),
              Text(textAlign: TextAlign.center,loadingTexts[random.nextInt(5)]),
              const SizedBox(height: 20,),
            ],)
        ),
      ),
    );
  } 
