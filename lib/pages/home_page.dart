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
import 'package:homeasz/components/appliance_button.dart';
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
            child: MainWindow(),
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

class MainWindow extends StatefulWidget {

  const MainWindow({
    super.key,
  });

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
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
          padding: const EdgeInsets.only(top: 5),
          // height should be to the bottom of the screen
          child: Column(
            textBaseline: TextBaseline
                .alphabetic, // this is to make the text align to the top
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hi Priyansh',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0.04,
                  letterSpacing: -0.72,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'what would you like to do?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF907C7C),
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 0.08,
                  letterSpacing: -0.39,
                ),
              ),
              const SizedBox(height: 50),
            
              // horizontal scroll list
              Container(
                height: 86,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10);
                  },
                  itemBuilder: (context, index) {
                    return Padding(padding: EdgeInsets.only(bottom: 4),child: ApplianceButton(
                        index: index,
                        applianceName: 'Switch $index',
                    ));
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
