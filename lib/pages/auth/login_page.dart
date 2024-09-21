import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homeasz/components/my_textfield.dart';
import 'package:homeasz/components/my_button.dart';
import 'package:homeasz/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signIn(AuthProvider authProvider) async {
    final String email = emailController.text;
    final String password = passwordController.text;
    
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    await authProvider.login(context, email, password);
    
    if (authProvider.user != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hello there!',
                    style: GoogleFonts.alice
                     (color: Colors.black,
                     fontSize: 48,
                     fontWeight: FontWeight.w400,
                     height: 0.02,
                     letterSpacing: -1.44,
                     ),
                  ),
                  SizedBox(height: height*0.05),
                  Text(
                    'Welcome back. Use your email and \npassword to log in.!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inriaSerif
                     (color: const Color(0xFF907C7C),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.05,
                      letterSpacing: -0.48,
                     ),
                  ),
                  // email textfield
                  SizedBox(height: height*0.08),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    icon: const AssetImage('lib/assets/Mail.png'),
                  ),

                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    icon: const AssetImage('lib/assets/Lock.png'),
                    iconSize: 24,
                  ),

                  const SizedBox(height: 0),

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: GoogleFonts.inriaSerif(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  MyButton(
                    onTap: () {
                      signIn(authProvider);
                    },
                    text: 'Log In',
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: GoogleFonts.inriaSerif(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Sign up',
                            style: GoogleFonts.inriaSerif(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
