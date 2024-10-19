import 'package:flutter/material.dart';
import 'package:homeasz/components/modal_sheets/modal_confirm_button.dart';
import 'package:homeasz/components/my_dropdownmenu.dart';
import 'package:homeasz/components/text_input.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/constants.dart';
import 'package:homeasz/utils/image_paths.dart';
import 'package:provider/provider.dart';

class AddToHomeFavourites extends StatefulWidget {
  const AddToHomeFavourites({super.key});

  @override
  State<AddToHomeFavourites> createState() => _AddToHomeFavouritesState();
}

class _AddToHomeFavouritesState extends State<AddToHomeFavourites> {
  late String selectedRoom;
  late String selectedType;
  late SwitchModel selectedSwitch;
  bool selectedSomething = false;

  void updateHomePageSwitches(DataProvider dataProvider){
    dataProvider.addToHomePageSwitches(selectedRoom,selectedSwitch);
  }

  @override
  Widget build(BuildContext context) {
    // provider 
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
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
          if(selectedSomething)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Image(
                    image: AssetImage(
                        '$applianceImagePath/${selectedType.toLowerCase()}true.png')),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 4,
                child: Text(
                   "${selectedRoom}'s ${selectedSwitch.name}",
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          MyDropdownMenu(
            title: "Room",
            list: dataProvider.rooms,
            initialSelection: "Select room",
            onSelected: (Room room) {
              setState(() {
                selectedRoom = room.name;
                dataProvider.getSwitches(roomName: selectedRoom);
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          MyDropdownMenu(
            title: "Device",
            list: dataProvider.switches,
            initialSelection: "Select device",
            onSelected: (SwitchModel switchSelection) {
              setState(() {
                selectedType = switchSelection.type;
                selectedSwitch = switchSelection;
                selectedSomething = true;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ModalConfirmButton(buttonText: "Add", onPressed: () {updateHomePageSwitches(dataProvider);  Navigator.pop(context);}),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
