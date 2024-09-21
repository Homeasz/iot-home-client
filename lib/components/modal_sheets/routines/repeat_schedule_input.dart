import 'package:flutter/material.dart';
import 'package:homeasz/components/modal_sheets/routines/time_input.dart';
import 'package:homeasz/components/modal_sheets/routines/weekday_input.dart';

class RepeatScheduleInput extends StatelessWidget {
  const RepeatScheduleInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 313,
      height: 52,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
            const BoxShadow(
                color: Color(0xffffffff), offset: Offset(-3, -3), blurRadius: 0)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 10,
          ),
          const TimeInput(),
          const SizedBox(width: 15,),
          WeekdayInput()
        ],
      ),
    );
  }
}
