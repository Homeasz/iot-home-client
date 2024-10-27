import 'package:flutter/material.dart';
import 'package:homeasz/components/add_button.dart';
import 'package:homeasz/pages/windows/home_window.dart';
import 'package:homeasz/pages/windows/rooms_window.dart';
import 'package:homeasz/pages/windows/routine_window.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int currentRoom = 0;
  int currentAnimationPos = 0; // 0 for loading, 1 for home view, 2 for others
  int currentWindow =
      0; // 0 for home, 1 for rooms, 2 for routines, 3 for add device

  // final info = NetworkInfo();

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getUser();
    Provider.of<DataProvider>(context, listen: false).getUserRooms();
    Provider.of<DataProvider>(context, listen: false).getUserRoutines();

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          currentAnimationPos = 1;
        });
      }
    });
  }

  void _fullPage(int pos) {
    setState(() {
      currentAnimationPos = pos;
    });
  }

  void _changeWindow(int window) {
    setState(() {
      currentWindow = window;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final List<double> sofaPos = [screenHeight / 2 - 250, 55, -500];
    final List<double> mainWindow = [screenHeight, screenHeight / 3 - 65, 120];
    final List<double> navBar = [screenHeight, 340, 90];
    final List<dynamic> window = [
      const HomeWindow(),
      const RoomsWindow(),
      const RoutineWindow(),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8FF),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: mainWindow[currentAnimationPos],
            left: 0,
            child: window[currentWindow],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: sofaPos[currentAnimationPos],
            left: screenWidth / 2 - 170, // Center horizontally
            child: Image.asset(
              'lib/assets/sofa.png',
              width: 350,
              height: 200,
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: navBar[currentAnimationPos],
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
                      _changeWindow(1);
                    },
                  ),
                  InkWell(
                      onTap: () {
                        _fullPage(1);
                        _changeWindow(0);
                      },
                      child: const Text("Home")),
                  InkWell(
                      onTap: () {
                        _fullPage(2);
                        _changeWindow(2);
                      },
                      child: const Text("Routines")),
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: const Text("Profile")),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: AddButton(
                window: currentWindow,
              )),
          // Bottom widget sliding in
        ],
      ),
    );
  }
}
