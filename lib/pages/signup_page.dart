// sign up page with name, email, password, and confirm password fields

import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}