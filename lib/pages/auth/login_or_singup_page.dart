import 'package:flutter/material.dart';
import 'package:homeasz/pages/auth/login_page.dart';
import 'package:homeasz/pages/auth/signup_page.dart';

class LoginOrSignUpPage extends StatefulWidget {
  const LoginOrSignUpPage({Key? key}) : super(key: key);

  @override
  State<LoginOrSignUpPage> createState() => _LoginOrSignUpPageState();
}

class _LoginOrSignUpPageState extends State<LoginOrSignUpPage> {
  bool showLogin = true;

  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginPage(onTap: toggleView);
    } else {
      return SignUpPage(onTap: toggleView);
    }
  }
}
