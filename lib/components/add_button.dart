import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/components/add_to_home.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: const Color(0xFFB1E8FF),
        child: Container(
          height: 58,
          width: 58,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 2, offset: Offset(2, 2))
          ], borderRadius: BorderRadius.circular(50), color: Color(0xFFB1E8FF)),
          child: Image.asset(
            'lib/assets/add.png',
          ),
        ),
        onTap: () {
          showModalBottomSheet(
              context: context,
              useSafeArea: true,
              backgroundColor: Color(0xFFE7F8FF),
              builder: (context) {
                return const Wrap(children: [AddToHome()]);
              });
        });
  }
}
