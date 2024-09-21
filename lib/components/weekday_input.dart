import 'package:flutter/material.dart';

class WeekdayInput extends StatefulWidget {
  WeekdayInput({super.key});
  final Weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  @override
  State<StatefulWidget> createState() => _WeekdayInputState();
}

class _WeekdayInputState extends State<WeekdayInput> {
  List<bool> WeekdaySelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(2, 2),
            ),]
      ),
      child: Row(
          children: List.generate(7, (index) {
        return GestureDetector(
          child: Container(
            width: 25,
            height: 30,
            alignment: Alignment.center,
            child: Text(
              widget.Weekdays[index],
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                height: 0.06,
              ),
            ),
            decoration: BoxDecoration(
                  borderRadius: index == 0
                    ? BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4))
                    : index == 6
                        ? BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4))
                        : BorderRadius.all(Radius.zero),
                color: WeekdaySelected[index]
                    ? Color(0xFFB1E8FF)
                    : Color(0XFFD9D9D9)),
          ),
          onTap: () => setState(() {
            WeekdaySelected[index] = !WeekdaySelected[index];
          }),
        );
      })),
    );
  }
}
