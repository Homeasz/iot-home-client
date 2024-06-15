import 'package:flutter/material.dart';
import 'package:homeasz/pages/home_page.dart';
import 'package:homeasz/providers/auth_provider.dart';
import 'package:homeasz/services/auth_service.dart';
import 'package:homeasz/pages/auth/login_or_singup_page.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAuthentication();
  }

  void _checkAuthentication() async {
    final authProvider = Provider.of<AuthProvider>(context);
    final isAuthenticated = await authProvider.isAuthenticated();
    setState(() {
      _isAuthenticated = isAuthenticated!;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return  const HomePage();
    } else {
      return  const LoginOrSignUpPage();
    }
  }
}
