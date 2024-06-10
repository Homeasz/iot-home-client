import 'package:flutter/material.dart';
import 'package:homeasz/models/profile_model.dart';
import 'package:homeasz/models/user_model.dart';
import 'package:homeasz/providers/auth_provider.dart';
import 'package:homeasz/providers/user_provider.dart';
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

  void addEsp() {
    Navigator.pushNamed(context, '/add_esp');
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final Profile? user = userProvider.profile;
    if (user == null) {
      userProvider.getUser();
    }
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Text('Welcome ${authProvider.user?.email ?? ''}'),
                ],
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                logout(authProvider);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              addEsp();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Welcome to HomeASZ!'),
            if (user != null)
              Text('You are logged in as ${user.email}')
            else
              const Text('You are not logged in'),
          ],
        ),
      ),
    );
  }
}
