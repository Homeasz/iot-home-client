import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dropdown extends StatefulWidget {
  Dropdown({super.key,this.fontSize = 18, required this.hint,required this.title});
  final double? fontSize;
  final String hint;
  final String title;


  @override
  State<StatefulWidget> createState() => _Dropdown();
}

class _Dropdown extends State<Dropdown> {
  final List<String> items = [
    'Turn On',
    'Turn Off',
    'Option 3',
    'Option 4',
  ];
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          // Grey border container
          Positioned(
              left: 0,
              right: 0,
              top: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Color(0xFFC2BCBC), width: 3),
                  ),
                ),
              )),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                menuMaxHeight: 150,
                hint: Text(
                  widget.hint,
                  style: GoogleFonts.poppins(
                      fontSize: widget.fontSize, color: Color(0xFFC2BCBC)),
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
                  fontSize: widget.fontSize, // Font size for dropdown items
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
                          fontSize: widget.fontSize), // Font size for dropdown items
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Positioned(
            top: 15,
            left:  widget.fontSize! > 15 ? 250 : 100,
            child: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFFC2BCBC),
            ),
          ),
          // "Rooms" label with white background
          Positioned(
            left: 14,
            top: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12, // Font size for "Rooms" label
                ),
              ),
            ),
          ),
        ],
      );
  }
}
