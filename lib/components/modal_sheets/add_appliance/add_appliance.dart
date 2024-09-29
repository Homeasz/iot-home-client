import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/components/modal_sheets/add_appliance/appliance_grid.dart';
import 'package:homeasz/components/modal_sheets/modal_confirm_button.dart';
import 'package:homeasz/components/text_input.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:provider/provider.dart';

class AddAppliance extends StatefulWidget {
  const AddAppliance({
    super.key,
  });

  @override
  State<AddAppliance> createState() => _AddApplianceState();
}

class _AddApplianceState extends State<AddAppliance> {
  final TextEditingController _textEditingController = TextEditingController();
  int _selectedApplianceIndex = -1;
  String _selectedApplianceName = "";

  void _addAppliance(context, DataProvider dataProvider) {
    if (_selectedApplianceIndex != -1) {
      // get current room
      int roomId = dataProvider.currentRoom!;

      // dataProvider.addDevice(_selectedApplianceName, roomId);
      // Add the appliance to the database or perform any other action
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // provider to get the list of appliances
    final DataProvider dataProvider = Provider.of<DataProvider>(context);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              height: 25,
            ),
            Text(
              "Add Device",
              style: GoogleFonts.poppins(
                color: const Color(0xFF000000),
                fontSize: 22,
                height: 0.05,
                letterSpacing: -0.66,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TextInput(
              input: _textEditingController,
              hintText: "Enter device name",
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Choose Device Label',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  color: Colors.grey[400],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 0.06,
                  letterSpacing: -0.54,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ApplianceGrid(onApplianceSelected: (index, name) {
              setState(() {
                _selectedApplianceIndex = index;
                _selectedApplianceName = name;
              });
            }),
            ModalConfirmButton(
                buttonText: "Add",
                onPressed: () {
                  _addAppliance(context, dataProvider);
                }),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
