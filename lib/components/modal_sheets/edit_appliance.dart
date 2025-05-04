import 'package:flutter/material.dart';
import 'package:homeasz/components/modal_sheets/modal_confirm_button.dart';
import 'package:homeasz/components/my_dropdownmenu.dart';
import 'package:homeasz/components/text_input.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/constants.dart';
import 'package:homeasz/utils/image_paths.dart';
import 'package:provider/provider.dart';

class EditAppliance extends StatefulWidget {
  const EditAppliance(
      {super.key,
      required this.applianceName,
      required this.applianceType,
      required this.roomId,
      required this.applianceId});

  final String applianceName;
  final String applianceType;
  final int roomId;
  final int applianceId;

  @override
  State<EditAppliance> createState() => _EditApplianceState();
}

class _EditApplianceState extends State<EditAppliance> {
  final TextEditingController _textEditingController = TextEditingController();
  late int selectedRoomId;
  String? selectedRoomName;
  late String selectedType;
  bool warn = false;

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.applianceName;
    selectedRoomId = widget.roomId;
    selectedType = widget.applianceType;
  }

  void updateAppliance(DataProvider dataProvider) {
    if (selectedRoomName == null) {}
    dataProvider.editSwitch(widget.applianceId, _textEditingController.text,
        selectedRoomName!, selectedRoomId, widget.roomId, selectedType);
    Navigator.pop(context);
  }

  void deleteAppliance(DataProvider dataProvider) {
    dataProvider.deleteSwitch(widget.applianceId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // provider
    final smallCaseType = selectedType.toLowerCase();
    final dataProvider = Provider.of<DataProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(
          // bottom: MediaQuery.sizeOf(context).viewInsets.bottom,
          left: 20,
          right: 20),
      child: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Image(
                    image: AssetImage(
                        '$applianceImagePath/${smallCaseType}true.png')),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 4,
                child: MyTextInput(
                  input: _textEditingController,
                  hintText: "Enter device name",
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          MyDropdownMenu(
            title: "Type",
            list: applianceNames,
            initialSelection: smallCaseType,
            onSelected: (String value) {
              setState(() {
                selectedType = value;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          MyDropdownMenu(
            title: "Choose Room",
            list: dataProvider.rooms,
            initialSelection: dataProvider.getRoomFromId(selectedRoomId),
            onSelected: (Room room) {
              setState(() {
                selectedRoomId = room.id;
                selectedRoomName = room.name;
                warn = false;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: warn,
            child: const Column(children: [
              Text("Please select a room!",
                  style: TextStyle(color: Colors.red)),
              SizedBox(
                height: 20,
              ),
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ModalConfirmButton(
                  buttonText: "Delete",
                  onPressed: () => deleteAppliance(dataProvider)),
              const SizedBox(
                width: 20,
              ),
              ModalConfirmButton(
                  buttonText: "Edit",
                  onPressed: () => (selectedRoomName == null)
                      ? setState(() {
                          warn = true;
                        })
                      : updateAppliance(dataProvider)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
