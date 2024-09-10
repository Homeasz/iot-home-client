import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplianceButton extends StatefulWidget {
  const ApplianceButton({
    super.key,
    required this.index,
    required this.applianceName,
  });

  final int index;
  final String applianceName;

  @override
  State<ApplianceButton> createState() => _ApplianceButtonState();
}

class _ApplianceButtonState extends State<ApplianceButton> {
  bool state = false;
  // change state of appliance
  void onTap() {
    setState(() {
      state = !state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    InkWell(
      onTap: onTap,
      child: Container(
      height: 74,
      width: 94,
      decoration: BoxDecoration(
          color: state? Color(0xFF87CEEB): Color(0xFFE6E6E6),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade600,
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
            const BoxShadow(
                color: Color(0xffffffff),
                offset: Offset(-3, -3),
                blurRadius: 5)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/assets/appliances/chandelier$state.png',
            height: 30,
          ),
          Text(
            'Living Room\'s \nFan',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                height: 1.2,
                letterSpacing: -0.39),
          )
        ],
      ),
    ));
  }
}
