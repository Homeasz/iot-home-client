import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final ImageProvider? icon;
  final double? iconSize;

  const MyTextField({
    super.key,
    this.icon,
    this.iconSize = 30,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(16, 21, 0, 21),
          isDense: true,
          prefixIcon: (icon!=null)? Padding(padding: const EdgeInsets.only(left:16, right:8), child: ImageIcon(icon!,size:  iconSize,)) : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400), 
          ),
          fillColor: const Color(0xfffaf8f8),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500])
        ),
      ),
    );
  }
}