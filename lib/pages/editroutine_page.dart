import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:homeasz/components/modal_sheets/modal_confirm_button.dart';
import 'package:homeasz/components/my_button.dart';
import 'package:homeasz/components/my_dropdownmenu.dart';
import 'package:homeasz/components/text_input.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/routine_model.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/models/utils/action_model.dart' as action_model;
import 'package:homeasz/models/utils/timer_model.dart' as timer_model;
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/image_paths.dart';
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
  bool _repeatRoutine = true;
  get repeatRoutine => _repeatRoutine;

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

  List<DayInWeek> _days = [
    DayInWeek("M", dayKey: "monday"),
    DayInWeek("T", dayKey: "tuesday"),
    DayInWeek("W", dayKey: "wednesday"),
    DayInWeek("T", dayKey: "thursday"),
    DayInWeek("F", dayKey: "friday"),
    DayInWeek("S", dayKey: "saturday", isSelected: true),
    DayInWeek("S", dayKey: "sunday", isSelected: true),
  ];

  // selected switches set
  Map<int, RoutineSwitchUI> routineSwitches = {};
  RoutineUI? routine;
  bool warnEmptyRoutineName = false;
  String? errorNoDeviceAdded;
  final TextEditingController routineNameController = TextEditingController();

  @override
  //TODO: this rebuilds every time a device card is clicked
  Widget build(BuildContext context) {
    // selected room
    // selected switch
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    int? routineId = ModalRoute.of(context)!.settings.arguments as int?;
    routine = dataProvider.getRoutineUI(routineId);

    if (routine != null) {
      log("$TAG routine: ${routine!.routineName}");
      routineNameController.text = routine!.routineName;
      time = routine!.time;
      _days = routine!.repeatDays;
      routineSwitches = routine!.routineSwitches;
    }

    void updateRoutineSwitches(RoutineSwitchUI routineSwitch) {
      setState(() {
        routineSwitches.update(
            routineSwitch.powerSwitch.id, (value) => routineSwitch,
            ifAbsent: () => routineSwitch);
      });
    }

    Future<void> addSwitchDialog(RoutineSwitchUI? routine) async {
      String? errorAddDeviceMessage;
      List<action_model.ActionModel> listActions = action_model.getList();
      List<timer_model.TimerModel> listTimer = timer_model.getList();
      action_model.ActionModel selectedAction = listActions[0];
      timer_model.TimerModel selectedTimer = listTimer[0];
      Room? selectedRoom;
      PowerSwitch? selectedSwitch;
      if (routine != null) {
        selectedRoom = dataProvider.getRoomFromId(routine.room
            .id); //routine.room can't be passed directly, since the initialSelection Room Object should be an element of the list which is passed to dropdown menu, list is made from dataProvder._rooms
        selectedAction = listActions.firstWhere(
            (element) => element.action.value == routine.action.action.value);
        selectedTimer = listTimer.firstWhere(
            (element) => element.timer.value == routine.timer.timer.value);
        await dataProvider.getSwitches(routine.room.id, routine.room.name);
        selectedSwitch = dataProvider.switches[selectedRoom?.id]?.firstWhere(
          (element) {
            log("$TAG element.id: ${element.id}, powerSwitch.id: ${routine.powerSwitch.id}");
            return element.id == routine.powerSwitch.id;
          },
        );
      }

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
                                    errorAddDeviceMessage = null;
                                  });
                                  selectedRoom = value;
                                  dataProvider.getSwitches(
                                      value.id, value.name);
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Visibility(
                                visible: selectedRoom != null,
                                child: Column(children: [
                                  MyDropdownMenu(
                                    title: "Switch",
                                    list: dataProvider
                                            .switches[selectedRoom?.id] ??
                                        [],
                                    initialSelection: selectedSwitch,
                                    onSelected: (PowerSwitch value) {
                                      setState(() {
                                        errorAddDeviceMessage = null;
                                      });
                                      selectedSwitch = value;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ]),
                              ),
                              Visibility(
                                visible: selectedSwitch != null,
                                child: Column(
                                  children: [
                                    MyDropdownMenu(
                                      title: "Action",
                                      initialSelection: selectedAction,
                                      list: listActions,
                                      onSelected:
                                          (action_model.ActionModel value) {
                                        setState(() {
                                          errorAddDeviceMessage = null;
                                        });
                                        selectedAction = value;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: (selectedAction.action ==
                                    action_model.Action.turnOn),
                                child: MyDropdownMenu(
                                  title: "Timer",
                                  initialSelection: selectedTimer,
                                  list: listTimer,
                                  onSelected: (timer_model.TimerModel value) {
                                    setState(() {
                                      errorAddDeviceMessage = null;
                                    });
                                    selectedTimer = value;
                                  },
                                ),
                              ),
                              if (errorAddDeviceMessage != null) ...[
                                const SizedBox(height: 10),
                                Text(
                                  errorAddDeviceMessage!,
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
                              Visibility(
                                visible: selectedSwitch != null,
                                child: ModalConfirmButton(
                                    buttonText: "Save",
                                    onPressed: () {
                                      if (selectedRoom == null ||
                                          selectedSwitch == null) {
                                        return;
                                      }
                                      updateRoutineSwitches(RoutineSwitchUI(
                                          room: selectedRoom!,
                                          powerSwitch: selectedSwitch!,
                                          action: selectedAction,
                                          timer: selectedTimer));
                                      errorNoDeviceAdded = null;
                                      Navigator.pop(context);
                                    }),
                              ),
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
            if (routineName == '') {
              log("Setting routine warning to true");
              setState(() {
                warnEmptyRoutineName = true;
              });
              return;
            }
            if (routineSwitches.isEmpty) {
              setState(() {
                errorNoDeviceAdded = "Add at least 1 device!";
              });
              return;
            }
            if (!repeatRoutine) {
              for (var day in _days) {
                day.isSelected = false;
              }
            }
            routine = RoutineUI(
                routineName: routineName,
                type: "morning",
                repeatDays: _days,
                time: time!,
                routineSwitches: routineSwitches);
            dataProvider.createRoutine(routine!);
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
                    hintText: 'Enter Routine Name',
                    isWarning: warnEmptyRoutineName,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        const Text(
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
                        const SizedBox(width: 20),
                        Switch(
                            value: repeatRoutine,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _repeatRoutine = value;
                              });
                            })
                      ],
                    ),
                  ),
                  Visibility(
                    visible: repeatRoutine,
                    child: Column(
                      children: [
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
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Color(0xFFE7F8FF),
                                            onPrimary:
                                                Color.fromARGB(255, 0, 2, 4),
                                            surface: Color.fromARGB(
                                                255, 166, 201, 255),
                                            onSurface:
                                                Color.fromARGB(255, 0, 2, 4),
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
                                  selectedDaysFillColor:
                                      const Color(0xFFE7F8FF),
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
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(height: 20),
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
                          addSwitchDialog(null);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (errorNoDeviceAdded != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      errorNoDeviceAdded!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
                      children: routineSwitches.values.map((routineSwitch) {
                        return ListTile(
                          leading: Image.asset(
                            '$applianceImagePath/${routineSwitch.powerSwitch.type.toLowerCase()}${routineSwitch.action.action.value ? 'true' : 'false'}.png',
                          ),
                          subtitle: Text(routineSwitch.room.name ?? ''),
                          title: Text(routineSwitch.powerSwitch.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                routineSwitches
                                    .remove(routineSwitch.powerSwitch.id);
                              });
                            },
                          ),
                          onTap: () => addSwitchDialog(routineSwitch),
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

  String TAG = "EditRoutinePage:";
}
