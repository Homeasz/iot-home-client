import 'package:flutter/material.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:provider/provider.dart';

class RoomPage extends StatefulWidget {
  final int roomIndex;

  const RoomPage({super.key, required this.roomIndex});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  // switch states as a array

  List<SwitchModel> switches = [];

  bool editRoomName = false;
  final TextEditingController roomNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSwitches();
  }

  void _fetchSwitches() async {
    final DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    String roomId = dataProvider.rooms[widget.roomIndex].id.toString();
    await dataProvider.getSwitches(roomId);
    setState(() {
      switches = dataProvider.switches;
    });
  }

  void toggleEditRoomName() async {
    if(editRoomName){
      final DataProvider dataProvider = Provider.of<DataProvider>(context, listen: false);
    String roomId = dataProvider.rooms[widget.roomIndex].id.toString();
    await dataProvider.editRoom(roomId, roomNameController.text);
    }
    
    setState(() {
      editRoomName = !editRoomName;
    });
  }

  void _toggleSwitch(int switchIndex, DataProvider dataProvider) async {
    final switchModel = switches[switchIndex];
    dataProvider.toggleSwitch(switchModel.id.toString(), !switchModel.state);
  }

  Future openDialog (BuildContext context) async {
    final DataProvider dataProvider = Provider.of<DataProvider>(context, listen: false);
    final TextEditingController switchBoardNameController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Switch Board'),
          content:  TextField(
            decoration: const InputDecoration(

            ),
            controller: switchBoardNameController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                dataProvider.addSwitchBoard(widget.roomIndex, switchBoardNameController.text);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider = Provider.of<DataProvider>(context);
    final Room room = dataProvider.rooms[widget.roomIndex];
    roomNameController.text = room.name;

    return Scaffold(
      appBar: AppBar(
        title: editRoomName
            ? TextField(
                controller: roomNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter room name',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  setState(() {
                    // room.name = value;
                    editRoomName = false;
                  });
                },
              )
            : Text(room.name),
        actions: [
          IconButton(
            icon: Icon(editRoomName ? Icons.save : Icons.edit),
            onPressed: toggleEditRoomName,
          )
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // room id
              'Room ID: ${room.id}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            // rows of switches
            Expanded(
              child: ListView.builder(
                itemCount: switches.length,
                itemBuilder: (context, index) {
                  final switchModel = switches[index];
                  return Dismissible(
                    key: Key(switchModel.id.toString()),
                    onDismissed: (direction) {
                      dataProvider.deleteSwitch(switchModel.id.toString());
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete),
                    ),
                    child: ListTile(
                      title: Text(
                        '${switchModel.name}-${switchModel.id}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: Switch(
                        value: switchModel.state,
                        onChanged: (value) {
                          _toggleSwitch(index, dataProvider);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // dataProvider.addSwitchBoard(widget.roomIndex);
                    openDialog(context);
                  },
                  child: const Text('Add Switch Board'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              'Created at: ${room.createdAt}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Updated at: ${room.updatedAt}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
