import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:homeasz/components/room_tile.dart';
import 'package:homeasz/components/switch_tile.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/models/user_model.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/providers/auth_provider.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:network_info_plus/network_info_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isBottomWidgetVisible = false;
  int currentRoom = 0;

  // final info = NetworkInfo();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        _isBottomWidgetVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8FF),
      body: SafeArea(
          child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: _isBottomWidgetVisible
                ? screenHeight / 5
                : screenHeight, // adjust values as needed
            left: 0,
            child: MainWindow(),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: _isBottomWidgetVisible
                ? -80
                : screenHeight / 2 - 250, // adjust values as needed
            left: screenWidth / 2 - 170, // Center horizontally
            child: Image.asset(
              'lib/assets/sofa.png',
              width: 350,
              height: 350,
            ),
          ),
          // Bottom widget sliding in
        ],
      )),
    );
  }
}

class MainWindow extends StatelessWidget {
  const MainWindow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          // height should be to the bottom of the screen
          child: Column(
            children: [
              Text(
                'Hi Priyansh',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  textBaseline: TextBaseline.alphabetic,
                  
                ),
                
              )
            ],
          ),
        ));
  }
}
