import 'package:flutter/material.dart';
import 'package:homeasz/components/modal_sheets/modal_confirm_button.dart';
import 'package:homeasz/components/my_dropdownmenu.dart';
import 'package:homeasz/components/text_input.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/constants.dart';
import 'package:homeasz/utils/image_paths.dart';
import 'package:provider/provider.dart';

class EditAppliance extends StatefulWidget {
  const EditAppliance(
      {super.key,
      required this.applianceName,
      required this.applianceType,
      required this.roomName,
      required this.applianceId});

  final String applianceName;
  final String applianceType;
  final String roomName;
  final int applianceId;

  @override
  State<EditAppliance> createState() => _EditApplianceState();
}

class _EditApplianceState extends State<EditAppliance> {
  final TextEditingController _textEditingController = TextEditingController();
  late String selectedRoom;
  late String selectedType;
  
  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.applianceName;
    selectedRoom = widget.roomName;
    selectedType = widget.applianceType;
  }

  void updateAppliance() {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.editSwitch(widget.applianceId, _textEditingController.text, selectedRoom, selectedType);
    Navigator.pop(context);
  }



  @override
  Widget build(BuildContext context) {
    // provider 
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
                        '$applianceImagePath/${selectedType}true.png')),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 4,
                child: TextInput(
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
            initialSelection: widget.applianceType,
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
            list: dataProvider.rooms.map((e) => e.name).toList(),
            initialSelection: widget.roomName,
            onSelected: (String value) {
              setState(() {
                selectedRoom = value;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ModalConfirmButton(buttonText: "Edit", onPressed: () {}),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
