import 'dart:developer';

import 'package:flutter/material.dart';

class MyDropdownMenu extends StatelessWidget {
  final List<dynamic> list;
  final String title;
  final dynamic initialSelection;
  final Function onSelected;
  final bool enabled;

  const MyDropdownMenu({
    super.key,
    required this.list,
    required this.title,
    required this.initialSelection,
    required this.onSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(
        child: Text(
          "No items available for selection",
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }
    return DropdownMenu<dynamic>(
      enabled: enabled,
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
        side: WidgetStateProperty.all(const BorderSide(
          color: Color(0xFFE7F8FF),
          width: 5,
        )),
      ),
      dropdownMenuEntries: list
          .map<DropdownMenuEntry<dynamic>>((item) => DropdownMenuEntry(
                style: MenuItemButton.styleFrom(
                    // foregroundColor: const Color(0xFFE7F8FF),
                    // backgroundColor: const Color(0xFFE7F8FF),

                    ),
                label: (item is String) ? item : item.name,
                // child: Text(roomName),
                value: item,
              ))
          .toList(),
    );
  }

  final String TAG = "MyDropdownMenu";
}
