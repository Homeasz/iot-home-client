import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeasz/components/modal_sheets/modal_confirm_button.dart';
import 'package:homeasz/components/my_button.dart';
import 'package:homeasz/components/my_dropdownmenu.dart';
import 'package:homeasz/components/text_input.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:day_picker/day_picker.dart';

class EditroutinePage extends StatefulWidget {
  const EditroutinePage({super.key});

  @override
  State<EditroutinePage> createState() => _EditroutinePageState();
}

class _EditroutinePageState extends State<EditroutinePage> {
  late DataProvider dataProvider;

  // define time state
  TimeOfDay? time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.getUserRooms().then((_) {
      if (dataProvider.rooms.isNotEmpty) {
        dataProvider.currentRoom = dataProvider.rooms[0].id;
        dataProvider.getSwitches(
          dataProvider.rooms[0].id,
          dataProvider.rooms[0].name,
        );
      }
    });
  }

  @override
  void dispose() {
    dataProvider.selectedSwitches = [];
    super.dispose();
  }

  final List<DayInWeek> _days = [
    DayInWeek("M", dayKey: "monday"),
    DayInWeek("T", dayKey: "tuesday"),
    DayInWeek("W", dayKey: "wednesday"),
    DayInWeek("T", dayKey: "thursday"),
    DayInWeek("F", dayKey: "friday"),
    DayInWeek("S", dayKey: "saturday", isSelected: true),
    DayInWeek("S", dayKey: "sunday", isSelected: true),
  ];

  // selected switches set
  final Set<int> selectedSwitches = {};

  @override
  Widget build(BuildContext context) {
    final TextEditingController routineNameController = TextEditingController();

    // selected room
    // selected switch
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    Room? selectedRoom;
    PowerSwitch? selectedSwitch;

    if (dataProvider.rooms.isNotEmpty) {
      selectedRoom = dataProvider.rooms[0];
      if (dataProvider.switches.isNotEmpty) {
        selectedSwitch = dataProvider.switches[0];
      }
    }

    Future<void> addSwitchDialog() async {
      String? errorMessage;

      return showDialog(
          context: context,
          useSafeArea: true,
          // backgroundColor: const Color(0xFFE7F8FF),
          builder: (context) {
            return Dialog(
              backgroundColor: const Color(0xFFE7F8FF),
              child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      Room? selectedRoom = dataProvider.rooms.isNotEmpty
                          ? dataProvider.rooms[0]
                          : null;
                      PowerSwitch? selectedSwitch =
                          dataProvider.switches.isNotEmpty
                              ? dataProvider.switches[0]
                              : null;
                      return StatefulBuilder(builder: (context, setState) {
                        return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                height: 18,
                              ),
                              Container(
                                width: 80,
                                height: 4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: const Color(0xFFE3E3E3)),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              MyDropdownMenu(
                                title: "Room",
                                list: dataProvider.rooms,
                                initialSelection: selectedRoom,
                                onSelected: (Room value) {
                                  // Update switches dynamically when a new room is selected
                                  setState(() {
                                    errorMessage = null;
                                  });
                                  dataProvider.getSwitches(
                                      value.id, value.name);
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              MyDropdownMenu(
                                title: "Switches",
                                list: dataProvider.switches,
                                initialSelection: selectedSwitch,
                                onSelected: (PowerSwitch value) {
                                   setState(() {
                                    errorMessage = null;
                                  });
                                  selectedSwitch = value;
                                },
                              ),
                              if (errorMessage != null) ...[
                                const SizedBox(height: 10),
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
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
                                    if (selectedSwitches
                                        .contains(selectedSwitch!.id)) {
                                      HapticFeedback.mediumImpact();
                                      setState(() {
                                        errorMessage = 'Switch already added';
                                      });

                                      // show error message
                                      return;
                                    }
                                    selectedSwitches.add(selectedSwitch!.id);
                                    dataProvider.addSwitchToSelectedSwitches(
                                        selectedSwitch!);
                                    Navigator.pop(context);
                                  }),
                              const SizedBox(
                                height: 20,
                              )
                            ]);
                      });
                    },
                  )),
            );
          });
    }

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
      persistentFooterButtons: [
        MyButton(
          text: 'Save',
          onTap: () {
            // save routine
            final String routineName = routineNameController.text;
            final List<int> switchIds = dataProvider.selectedSwitches
                .map((PowerSwitch selectedSwitch) => selectedSwitch.id)
                .toList();
            final List<String> days = _days
                .where((DayInWeek day) => day.isSelected)
                .map((DayInWeek day) => day.dayKey)
                .toList();
            final String timeString = time!.format(context);
            // dataProvider.createRoutine(
            //   routineName: routineName,
            //   switchIds: switchIds,
            //   days: days,
            //   time: timeString,
            // );
            Navigator.pop(context);
          },
        ),
      ],
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
                  MyTextInput(
                      input: routineNameController,
                      hintText: 'Enter Routine Name'),
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
                  const SizedBox(height: 20),
                  // RepeatScheduleInput(),

                  Container(
                    // align content center
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 255, 255, 255),
                          // offset: Offset(1, 1),
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Text(time!.format(context),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,

                                // height: 0.06,
                                // letterSpacing: -0.54,
                              )),
                          onTap: () async {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: time!,
                              barrierColor: const Color(0xFFE7F8FF),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Color(0xFFE7F8FF),
                                      onPrimary: Color.fromARGB(255, 0, 2, 4),
                                      surface:
                                          Color.fromARGB(255, 166, 201, 255),
                                      onSurface: Color.fromARGB(255, 0, 2, 4),
                                    ),
                                    dialogBackgroundColor:
                                        const Color(0xFFE7F8FF),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (selectedTime == null) return;
                            setState(() {
                              time = selectedTime;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        SelectWeekDays(
                            selectedDayTextColor: Colors.black,
                            selectedDaysBorderColor: Colors.white,
                            selectedDaysFillColor: const Color(0xFFE7F8FF),
                            unSelectedDayTextColor: Colors.black,
                            elevation: 1,
                            borderWidth: 0,
                            onSelect: (values) {
                              print(values);
                            },
                            border: true,
                            boxDecoration: const BoxDecoration(),
                            days: _days)
                      ],
                    ),
                  ),
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
                          addSwitchDialog();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 255, 255, 255),
                          // offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: dataProvider.selectedSwitches
                          .map((PowerSwitch selectedSwitch) {
                        return ListTile(
                          leading: const Icon(Icons.lightbulb),
                          subtitle: Text(selectedSwitch.roomName ?? ''),
                          title: Text(selectedSwitch.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              if (selectedSwitches
                                  .contains(selectedSwitch.id)) {
                                selectedSwitches.remove(selectedSwitch.id);
                              }
                              dataProvider.removeSwitchFromSelectedSwitches(
                                  selectedSwitch);
                            },
                          ),
                        );
                      }).toList(),
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
