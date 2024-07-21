import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homeasz/components/room_tile.dart';
import 'package:homeasz/models/user_model.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/providers/auth_provider.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/providers/user_provider.dart';
import 'package:provider/provider.dart';
// import 'package:network_info_plus/network_info_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  // final info = NetworkInfo();

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
    // final wifiName = await info.getWifiName();
    // print(wifiName);
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
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final List<Room> rooms = Provider.of<DataProvider>(context).rooms;

    if (_isLoading || userProvider.user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
        elevation: 10,

        actions: [
          // drop down menu
          PopupMenuButton(

            icon: const Icon(Icons.add),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 'add_esp',
                  textStyle: TextStyle(color: Colors.blue),
                  child: Text('Add ESP'),
                ),
                const PopupMenuItem(
                  value: 'list_esp',
                  child: Text('List ESPs'),
                ),
                const PopupMenuItem(
                  value: 'add_room',
                  child: Text('Add Room'),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'add_esp') {
                openAddESPPage();
              } else if (value == 'list_esp') {
                openListESPPage();
              } else if (value == 'add_room') {
                openCreateRoomPage();
              }
            },
          ),
        ],
      ),

      body: rooms.isEmpty
          ? const Center(
              child: Text('No rooms found, add room'),
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
                  return RoomCard(index: index, roomName: rooms[index].name);
                },
                itemCount: rooms.length,
              ),
            ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add),
      //       label: 'Add Room',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: const Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      //   onTap: (index) {
      //     if (index == 0) {
      //       openCreateRoomPage();
      //     } else {
      //       openProfilePage();
      //     }
      //     // else if (index == 3) {
      //     //   openCreateRoomPage();
      //     // }
      //   },
      // ),
    );
  }
}
