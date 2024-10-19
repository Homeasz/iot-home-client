import 'package:flutter/material.dart';

class MyDropdownMenu extends StatelessWidget {
  final List<dynamic> list;
  final String title;
  final dynamic initialSelection;
  final Function onSelected;

  const MyDropdownMenu({
    super.key,
    required this.list,
    required this.title,
    required this.initialSelection,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<dynamic>(
      width: MediaQuery.sizeOf(context).width * 0.7,
      hintText: "Select Room",
      label: Text(title),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
    
      ),
      onSelected: (value) => onSelected(value),
      menuHeight: MediaQuery.sizeOf(context).height * 0.3,
      initialSelection: initialSelection,
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(const Color(0xFFE7F8FF)),
      ),
      dropdownMenuEntries: list
          .map<DropdownMenuEntry<dynamic>>((item) => DropdownMenuEntry(
                style: MenuItemButton.styleFrom(
                  // foregroundColor: const Color(0xFFE7F8FF),
                  // backgroundColor: const Color(0xFFE7F8FF),
    
                ),
                label: (item is String)? item : item.name,
                // child: Text(roomName),
                value: item,
              ))
          .toList(),
    );
  }
}
