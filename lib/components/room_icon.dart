import 'package:flutter/material.dart';

typedef MyBuilder = void Function(BuildContext context, void Function() methodFromChild);

class RoomIcon extends StatefulWidget{
  final MyBuilder builder;
  const RoomIcon({super.key,required this.roomId, required this.builder});
  final int roomId;
  @override
  State<StatefulWidget> createState() {
    return _RoomIconState();
  }
}

class _RoomIconState extends State<RoomIcon> {
  bool state = false;
  final List<String> roomNames = ["balcony","bed","door","kitchen","living-room","office-desk","sink","table"];
  
  void toggleState(){
    setState(() {
      state = !state;
    });
  }
  @override
  Widget build(BuildContext context) {
    widget.builder.call(context,toggleState);
    return SizedBox(width: 83,height: 83,
    child: Image.asset('lib/assets/rooms/${roomNames[widget.roomId]}$state.png'),);
  }
}