import 'package:flutter/material.dart';

class RoomsWindow extends StatefulWidget {
  const RoomsWindow({super.key});

  @override
  State<RoomsWindow> createState() => _RoomsWindowState();
}

class _RoomsWindowState extends State<RoomsWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      child: Text("Rooms Window"),
    );
  }
}