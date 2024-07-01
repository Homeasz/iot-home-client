import 'package:flutter/material.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:provider/provider.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  bool _isLoading = false;

  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController roomDescriptionController =
      TextEditingController();

  void createRoom(DataProvider dataProvider) async {
    final String roomName = roomNameController.text;
    final String roomDescription = roomDescriptionController.text;
    await dataProvider.addRoom(roomName);

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Room'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a new room',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: roomNameController,
                    decoration: const InputDecoration(
                      labelText: 'Room Name',
                      hintText: 'Enter the room name',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: roomDescriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Room Description',
                      hintText: 'Enter the room description',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      createRoom(dataProvider);
                    },
                    child: const Text('Create'),
                  ),
                ],
              ),
            ),
    );
  }
}
