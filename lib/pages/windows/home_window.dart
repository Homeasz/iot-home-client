import 'package:flutter/material.dart';
import 'package:homeasz/pages/windows/home_window_favourite_switches.dart';
import 'package:homeasz/pages/windows/home_window_favourite_tiles.dart';
import 'package:homeasz/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HomeWindow extends StatefulWidget {
  const HomeWindow({
    super.key,
  });

  @override
  State<HomeWindow> createState() => _HomeWindowState();
}

class _HomeWindowState extends State<HomeWindow> {
  // call the user provider to get the user
  @override
  void initState() {
    super.initState();
  }

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
          child: Consumer<UserProvider>(
              builder: (context, userProvider, child) => Column(
                    textBaseline: TextBaseline
                        .alphabetic, // this is to make the text align to the top
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi ${userProvider.user?.firstName},',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
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
                            ],
                          ),
                          //  profile icon
                          const Spacer(),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7F8FF),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/profile');
                              },
                              child: const Icon(
                                LineAwesomeIcons.user_astronaut_solid,
                                color: Color(0xFF00A3FF),
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 60),
                      // horizontal scroll list
                      const HomeWindowFavouriteSwitches(),
                      const HomeWindowFavouriteTiles(),
                    ],
                  )),
        ));
  }
}
