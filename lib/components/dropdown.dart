import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});

  @override
  State<StatefulWidget> createState() => _Dropdown();
}

class _Dropdown extends State<Dropdown> {
  final List<String> items = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 275, // Updated width
      height: 60,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color(0xFFC2BCBC)),
              right: BorderSide(color: Color(0xFFC2BCBC))),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 0,
              blurRadius: 0,
              offset: const Offset(0.1, 0.1),
            ),
            const BoxShadow(
                color: Color(0xffffffff), offset: Offset(-3, -3), blurRadius: 5)
          ]),

      child: Stack(
        children: [
          // Grey border container
          Positioned(
              left: 0,
              right: 0,
              top: 10,
              child: Container(
                height: 39,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Color(0xFFC2BCBC), width: 3),
                ),
              )),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: DropdownButtonFormField<String>(
              hint: Text(
                'Select Room',
                style:
                    GoogleFonts.poppins(fontSize: 18, color: Color(0xFFC2BCBC)),
              ),
              isDense: true,
              iconDisabledColor: Color(0x00000000),
              iconEnabledColor: Color(0x00000000),
              value: selectedValue,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
              isExpanded: true,
              dropdownColor: Colors.white,
              style: GoogleFonts.poppins(
                fontSize: 18, // Font size for dropdown items
                color: Colors.black,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
              },
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                        fontSize: 18), // Font size for dropdown items
                  ),
                );
              }).toList(),
            ),
          ),

          Positioned(
            top: 18,
            left: 220,
            child: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFFC2BCBC),
            ),
          ),
          // "Rooms" label with white background
          Positioned(
            left: 16,
            top: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Rooms',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12, // Font size for "Rooms" label
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
