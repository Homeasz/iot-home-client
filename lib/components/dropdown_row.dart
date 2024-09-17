import 'package:flutter/material.dart';
import 'package:homeasz/components/dropdown.dart';
import 'package:homeasz/components/mini_dropdown.dart';
import 'package:http/http.dart';

class DropdownRow extends StatelessWidget{
  DropdownRow({super.key, required this.hint, required this.title});
  final String hint;
  final String title;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 313, // Updated width
      height: 52,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 0.2,
              blurRadius: 2,
              offset: const Offset(0.1, 0.1),
            ),
            const BoxShadow(
                color: Color(0xffffffff), offset: Offset(-3, -3), blurRadius: 0)
          ]),

      child: Dropdown(title: title,hint: hint),
      );
  }
}