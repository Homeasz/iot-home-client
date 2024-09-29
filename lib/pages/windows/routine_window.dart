import 'package:flutter/material.dart';

class RoutineWindow extends StatefulWidget {
  const RoutineWindow({super.key});

  @override
  State<RoutineWindow> createState() => _RoutineWindowState();
}

class _RoutineWindowState extends State<RoutineWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
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
      child: const Text("Routine Window"),
    );
  }
}
