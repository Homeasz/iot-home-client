import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/image_paths.dart';
import 'package:provider/provider.dart';



class BigTile extends StatefulWidget {
  const BigTile({
    super.key,
    required this.index,
    required this.tileName,
  });

  final int index;
  final String tileName;

  @override
  State<StatefulWidget> createState() => _BigTileState();
}

class _BigTileState extends State<BigTile> {
  bool switchState = false;

  void onTap() {
    setState(() {
      switchState = !switchState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 154,
        // width: 149,
        decoration: BoxDecoration(
            color:
                switchState ? const Color(0xFF87CEEB) : const Color(0xFFE6E6E6),
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
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    // alignment: Alignment.topLeft,
                    child: Image.asset(
                      'lib/assets/rooms/balcony$switchState.png',
                      height: 85,
                    ),
                  ),
                  Text(
                    'Living Room',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
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
                      padding: EdgeInsets.all(15),
                      child: Card(
                        margin: EdgeInsets.all(2),
                        elevation: 6,
                        color:
                            switchState ? Color(0xFFFFC700) : Color(0xFFFFFFFF),
                        shape: CircleBorder(),
                        child: Container(
                            padding: EdgeInsets.all(4),
                            child: SvgPicture.asset(
                                width: 20, 
                                powerImage
                            )
                        ),
                      )
                    )
                  ),
            ],
          ),
        ));
  }
}
