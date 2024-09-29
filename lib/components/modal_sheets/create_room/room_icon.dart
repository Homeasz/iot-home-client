import 'package:flutter/material.dart';
import 'package:homeasz/utils/image_paths.dart';

typedef MyBuilder = void Function(
    BuildContext context, void Function() methodFromChild);

class RoomIcon extends StatefulWidget {
  final MyBuilder builder;
  final String roomType;
  const RoomIcon({super.key, required this.roomType, required this.builder});
  @override
  State<StatefulWidget> createState() {
    return _RoomIconState();
  }
}

class _RoomIconState extends State<RoomIcon> {
  bool state = false;

  void toggleState() {
    setState(() {
      state = !state;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.builder.call(context, toggleState);
    return SizedBox(
      width: 83,
      height: 83,
      child: Image.asset('$roomImagePath/${widget.roomType}$state.png'),
    );
  }
}
