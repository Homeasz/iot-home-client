import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homeasz/components/modal_sheets/edit_appliance.dart';
import 'package:homeasz/components/modal_sheets/modal_confirm_button.dart';
import 'package:homeasz/components/my_dropdownmenu.dart';
import 'package:homeasz/components/my_textfield.dart';
import 'package:homeasz/components/text_input.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:provider/provider.dart';

class EditroutinePage extends StatefulWidget {
  const EditroutinePage({super.key});

  @override
  State<EditroutinePage> createState() => _EditroutinePageState();
}

class _EditroutinePageState extends State<EditroutinePage> {

  late DataProvider dataProvider;

  @override
  void initState() {
    super.initState();
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.getUserRooms();
    dataProvider.currentRoom = dataProvider.rooms[0].id;
  }

  @override
  void dispose() {
    dataProvider.selectedSwitches = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController routineNameController = TextEditingController();

    // selected room
    // selected switch
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    Room? selectedRoom = dataProvider.rooms[0];
    PowerSwitch? selectedSwitch = dataProvider.switches[0];

    return Scaffold(
      backgroundColor: const Color(0xFFE7F8FF),
      appBar: AppBar(
        title: const Text(
          'Edit Routine',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            // height: 0.06,
            // letterSpacing: -0.54,
          ),
        ),
        backgroundColor: const Color(0xFFE7F8FF),
      ),
      body: SafeArea(
        child: Consumer<DataProvider>(
          builder:
              (BuildContext context, DataProvider dataProvider, Widget? child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Routine Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        // height: 0.06,
                        // letterSpacing: -0.54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextInput(
                      input: routineNameController,
                      hintText: 'Enter Routine Name'),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        'Devices',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          // height: 0.06,
                          // letterSpacing: -0.54,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                              context: context,
                              useSafeArea: true,
                              // backgroundColor: const Color(0xFFE7F8FF),
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: const Color(0xFFE7F8FF),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(
                                          height: 18,
                                        ),
                                        Container(
                                          width: 80,
                                          height: 4,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: const Color(0xFFE3E3E3)),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        MyDropdownMenu(
                                          title: "Room",
                                          list: dataProvider.rooms,
                                          initialSelection:
                                              dataProvider.rooms[0],
                                          onSelected: (Room value) {
                                            setState(() {
                                              selectedRoom = value;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        MyDropdownMenu(
                                          title: "Switches",
                                          list: dataProvider.switches,
                                          initialSelection:
                                              dataProvider.switches[0],
                                          onSelected: (PowerSwitch value) {
                                            setState(() {
                                              selectedSwitch = value;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ModalConfirmButton(
                                            buttonText: "Add",
                                            onPressed: () {
                                              if (selectedRoom == null ||
                                                  selectedSwitch == null) {
                                                return;
                                              }
                                              dataProvider
                                                  .addSwitchToSelectedSwitches(
                                                      selectedSwitch!);
                                              Navigator.pop(context);
                                            }),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Repeat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        // height: 0.06,
                        // letterSpacing: -0.54,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
