import 'package:flutter/material.dart';
import 'package:homeasz/components/room_tile.dart';
import 'package:homeasz/models/user_model.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/providers/auth_provider.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

  Future<void> _fetchUserDetails() async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    await userProvider.getUser();


    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    
    if (userProvider.user == null) {
      await authProvider.logout();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }

    final DataProvider roomsProvider =
        Provider.of<DataProvider>(context, listen: false);

    await roomsProvider.getUserRooms();

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

  void openCreateRoomPage() {
    Navigator.pushNamed(context, '/create_room');
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  Drawer _drawer(User? user, BuildContext context, AuthProvider authProvider) {
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

  @override
  Widget build(BuildContext context) {
    final List<Room> rooms = Provider.of<DataProvider>(context).rooms;

    return Scaffold(
      key: scaffoldKey,
      // backgroundColor: Colors.grey[300],
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
          // text with gesture detector and icon
          GestureDetector(
            onTap: openCreateRoomPage,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Add Room',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : rooms.length == 0
              ? const Center(
                  child: Text('No rooms found'),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return RoomCard(
                          index: index, roomName: rooms[index].name);
                    },
                    itemCount: rooms.length,
                  ),
                ),
    );
  }
}
