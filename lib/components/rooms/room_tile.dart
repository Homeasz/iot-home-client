import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/constants.dart';
import 'package:homeasz/utils/image_paths.dart';
import 'package:provider/provider.dart';

class RoomTile extends StatefulWidget {
  const RoomTile({
    super.key,
    required this.index,
    required this.roomName,
    required this.roomType,
  });

  final int index;
  final String roomName;
  final String roomType;

  @override
  State<StatefulWidget> createState() => _RoomTileState();
}

class _RoomTileState extends State<RoomTile> {
  bool state = false;

  void onTap() {
    setState(() {
      state = !state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 154,
        // width: 149,
        decoration: BoxDecoration(
            color:
                state ? const Color(0xFF87CEEB) : const Color(0xFFE6E6E6),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(2, 2),
              ),
              const BoxShadow(
                color: Color(0xffffffff),
                blurRadius: 5,
                offset: Offset(-3, -3),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 2, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    // alignment: Alignment.topLeft,
                    child: Image.asset(
                      '$roomImagePath/${widget.roomType}${state ? 'true' : 'false'}.png',
                      height: MediaQuery.of(context).size.height * 0.10,
                      fit: BoxFit.contain,

                    ),
                  ),

                  // longer names will be cut off
                  Text(
                    widget.roomName.length > 7
                        ? widget.roomName.substring(0,7) + '...'
                        : widget.roomName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      height: 0.06,
                      letterSpacing: -0.54,
                    ),
                  ),
                ],
              ),
              InkWell(
                  onTap: onTap,
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Card(
                        margin: const EdgeInsets.all(2),
                        elevation: 6,
                        color: state
                            ? const Color(0xFFFFC700)
                            : const Color(0xFFFFFFFF),
                        shape: const CircleBorder(),
                        child: Container(
                            padding: const EdgeInsets.all(4),
                            child: SvgPicture.asset(width: 20, powerImage)),
                      ))),
            ],
          ),
        ));
  }
}
