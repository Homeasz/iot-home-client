import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/image_paths.dart';
import 'package:provider/provider.dart';

class ApplianceButton extends StatefulWidget {
  const ApplianceButton({
    super.key,
    required this.switchId,
    required this.applianceName,
    required this.type,
    this.roomName = "Home",
    this.state = false,
  });

  final int switchId;
  final String? roomName;
  final String type;
  final String applianceName;
  final bool state;

  @override
  State<ApplianceButton> createState() => _ApplianceButtonState();
}

class _ApplianceButtonState extends State<ApplianceButton> {
  bool state = false;

  @override
  void initState() {
    state = widget.state;
    super.initState();
  }
  // change state of appliance
  void onTap() {
    setState(() {
      state = !state;
    });
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.toggleSwitch(widget.switchId, state);
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
          color: state? const Color(0xFF87CEEB): const Color(0xFFE6E6E6),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(1, 2),
            ),
            const BoxShadow(
                color: Color(0xffffffff),
                offset: Offset(-2, -2),
                blurRadius: 5)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            '$applianceImagePath/${widget.type.toLowerCase()}${state ? 'true' : 'false'}.png',
            height:30,
            // fit: BoxFit.contain,
          ),
          Text(
            "${widget.roomName}'s ${widget.applianceName}",
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
