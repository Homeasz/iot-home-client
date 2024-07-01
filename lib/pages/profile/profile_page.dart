import 'package:flutter/material.dart';
import 'package:homeasz/models/auth_model.dart';
import 'package:homeasz/pages/profile/profile_menu_page.dart';
import 'package:homeasz/pages/profile/update_profile_page.dart';
import 'package:homeasz/providers/auth_provider.dart';
import 'package:homeasz/providers/theme_provider.dart';
import 'package:homeasz/providers/user_provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:homeasz/utils/constants.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);

    if (userProvider.user == null) {
      userProvider.getUser();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LineAwesomeIcons.angle_left_solid)),
        title: Text("User Profile",
            style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          IconButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              icon: Icon(themeProvider.isDarkMode
                  ? LineAwesomeIcons.sun
                  : LineAwesomeIcons.moon))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                      width: 120,
                      height: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          // child: const Image(image: AssetImage(tProfileImage))),
                          child: const Icon(
                            LineAwesomeIcons.user_astronaut_solid,
                            size: 60,
                          ),
                        ),
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).primaryColor),
                      child: const Icon(
                        LineAwesomeIcons.pencil_ruler_solid,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Text(
                      "${userProvider.user!.firstName} ${userProvider.user!.lastName}",
                      style: Theme.of(context).textTheme.headlineSmall);
                },
              ),
              // Text(userProvider.user!.email,
              //     style: Theme.of(context).textTheme.bodySmall),
              // const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UpdateProfileScreen())),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: const Text(
                      tEditProfile,
                      style: TextStyle(color: Colors.black),
                    )),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: "Settings",
                  icon: LineAwesomeIcons.cog_solid,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Billing Details",
                  icon: LineAwesomeIcons.wallet_solid,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "User Management",
                  icon: LineAwesomeIcons.user_check_solid,
                  onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Information",
                  icon: LineAwesomeIcons.info_circle_solid,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: Icons.logout,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("LOGOUT"),
                          content: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Text("Are you sure, you want to Logout?"),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () => {
                                authProvider.logout(),
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  side: BorderSide.none),
                              child: const Text("Yes"),
                            ),
                            OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("No")),
                          ],
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
