import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homeasz/models/user_model.dart';
import 'package:homeasz/models/auth_model.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/providers/auth_provider.dart';
import 'package:homeasz/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  // an array of room names with differenc colors
  final List<Room> rooms = [
    Room(name: 'Living Room', color: const Color.fromARGB(255, 177, 232, 168)),
    Room(name: 'Bedroom', color: const Color.fromARGB(255, 200, 212, 108)),
    Room(name: 'Kitchen', color: const Color.fromARGB(145, 218, 154, 52)),
    Room(name: 'Bathroom', color: const Color.fromARGB(255, 210, 180, 132)),
    Room(name: 'Living Room', color: const Color.fromARGB(255, 177, 232, 168)),
    Room(name: 'Bedroom', color: const Color.fromARGB(255, 200, 212, 108)),
    Room(name: 'Kitchen', color: const Color.fromARGB(145, 218, 154, 52)),
    Room(name: 'Bathroom', color: const Color.fromARGB(255, 210, 180, 132)),
    Room(name: 'Living Room', color: const Color.fromARGB(255, 177, 232, 168)),
    Room(name: 'Bedroom', color: const Color.fromARGB(255, 200, 212, 108)),
    Room(name: 'Kitchen', color: const Color.fromARGB(145, 218, 154, 52)),
    Room(name: 'Bathroom', color: const Color.fromARGB(255, 210, 180, 132)),
  ];

  Future<void> _fetchUserDetails() async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.getUser();
    setState(() {
      _isLoading = false;
    });
  }

  void logout(AuthProvider authProvider) async {
    await AuthProvider().logout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void openAddESPPage() {
    Navigator.pushNamed(context, '/add_esp');
  }

  void openListESPPage() {
    Navigator.pushNamed(context, '/list_esp');
  }

  void openProfilePage() {
    Navigator.pushNamed(context, '/profile');
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User? user = userProvider.user;
    return Scaffold(
      key: scaffoldKey,
      // backgroundColor: Colors.grey[300],
      drawer: _drawer(user, context, authProvider),
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.person), onPressed: openProfilePage
            // scaffoldKey.currentState!.openDrawer();
            ),
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //         begin: Alignment.topCenter,
        //         end: Alignment.bottomCenter,
        //         stops: [0.1, 0.9],
        //         colors: <Color>[Colors.blue, Colors.black]),
        //   ),
        // ),
        // elevation: 10,

        actions: [
          IconButton(
            onPressed: () {
              openAddESPPage();
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
              onPressed: () {
                openListESPPage();
              },
              icon: const Icon(Icons.list))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return RoomCard(rooms: rooms, index: index);
                },
                itemCount: rooms.length,
              ),
            ),
    );
  }

  Drawer _drawer(
      User? user, BuildContext context, AuthProvider authProvider) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Text('Welcome ${user?.firstName} ${user?.lastName}'),
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
    );
  }
}

class RoomCard extends StatelessWidget {
  const RoomCard({
    super.key,
    required this.rooms,
    required this.index,
  });

  final index;
  final List<Room> rooms;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: rooms[index].color,
      child: Center(
        child: Text(rooms[index].name),
      ),
    );
  }
}
