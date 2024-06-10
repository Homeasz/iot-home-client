import 'package:flutter/material.dart';
import 'package:homeasz/pages/auth_page.dart';
import 'package:homeasz/pages/samplewifiiot.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:homeasz/pages/login_page.dart';
import 'package:homeasz/pages/home_page.dart';
import 'package:homeasz/pages/signup_page.dart';
import 'package:homeasz/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homeasz/pages/addesp_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DataProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthPage(),
          '/add_esp':(context) => AddESPPage(),
        },
      ),
    );
  }
}
