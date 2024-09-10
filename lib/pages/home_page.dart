import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:homeasz/pages/windows/home_window.dart';
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
  int currentAnimationPos = 0;

  // final info = NetworkInfo();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _isBottomWidgetVisible = true;
        currentAnimationPos = 1;
      });
    });
  }

  void _fullPage(int pos) {
    setState(() {
      currentAnimationPos = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final List<double> _sofaPos = [screenHeight / 2 - 250, 55, -500];
    final List<double> _mainWindow = [screenHeight, screenHeight / 3 - 65, 120];
    final List<double> _navBar = [screenHeight, 300, 90];
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8FF),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: _mainWindow[currentAnimationPos],
            left: 0,
            child: HomeWindow(),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: _sofaPos[currentAnimationPos],
            left: screenWidth / 2 - 170, // Center horizontally
            child: Image.asset(
              'lib/assets/sofa.png',
              width: 350,
              height: 200,
            ),
          ),
          
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: _navBar[currentAnimationPos],
            left: 0,
            child: Container(
              height: 20,
              width: screenWidth,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: const Text("Rooms"),
                      onTap: () {
                          _fullPage(2);
                        },
                      ),
                    InkWell(
                        onTap: () {
                          _fullPage(1);
                        },
                        child: const Text("Home")),
                    InkWell(
                      onTap: () => _fullPage(2),
                      child: const Text("Routines")
                      ),
                    const Text("Profile"),
                  ],
                ),
            ),
          )
          
          // Bottom widget sliding in
        ],
      ),
    );
  }
}

