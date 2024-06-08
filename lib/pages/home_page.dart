import 'package:flutter/material.dart';
import 'package:homeasz/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logout(AuthProvider authProvider) async {
    await AuthProvider().logout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              logout(authProvider);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Welcome to HomeASZ!'),
            if (user != null)
             Text('You are logged in as ${authProvider.user!.email}')
            else
              const Text('You are not logged in'),
          ],
        ),
      ),
    );
  }
}
