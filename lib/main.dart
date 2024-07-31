import 'package:flutter/material.dart';
import 'package:homeasz/pages/auth/auth_page.dart';
import 'package:homeasz/pages/createroom_page.dart';
import 'package:homeasz/pages/profile/profile_page.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/providers/theme_provider.dart';
import 'package:homeasz/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:homeasz/providers/auth_provider.dart';
import 'package:homeasz/pages/addesp_page.dart';
import 'package:homeasz/pages/listesps_page.dart';
import 'package:homeasz/utils/themes.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => DataProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
  ], child:  MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Homeasz',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkMode ? darkTheme : lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        '/create_room': (context) => const CreateRoom(),
        '/add_esp': (context) => const AddESPPage(),
        '/list_esp': (context) => const ListESPsPage(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
