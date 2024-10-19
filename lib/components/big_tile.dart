import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/components/modal_sheets/edit_appliance.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/image_paths.dart';
import 'package:provider/provider.dart';

import '../pages/room_page.dart';

class BigTile extends StatefulWidget {
  const BigTile({
    super.key,
    required this.id,
    required this.index,
    required this.tileName,
    required this.tileType,
    this.appliance = false,
    this.roomName = 'Living Room',
    this.state = false,
  });

  final int id;
  final int index;
  final String tileName;
  final String tileType;
  final bool appliance;
  final String roomName;
  final bool state;

  @override
  State<StatefulWidget> createState() => _BigTileState();
}

class _BigTileState extends State<BigTile> {
  bool state = false;
  @override
  void initState(){
    super.initState();
    state = widget.state;
  }

  void onPowerTap() {
    setState(() {
      state = !state;
    });
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.toggleSwitch(widget.id, state);
  }

  void _navigateToRoomPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomPage(
          roomId: widget.id,
          roomName: widget.tileName,
          roomType: widget.tileType,
        ),
      ),
    );
  }

  void _showApplianceModal(BuildContext context) {
    showDialog(
        context: context,
        useSafeArea: true,
        // backgroundColor: const Color(0xFFE7F8FF),
        builder: (context) {
          return Dialog(
            backgroundColor: Color(0xFFE7F8FF),
            child: EditAppliance(
              applianceName: widget.tileName,
              applianceType: widget.tileType,
              roomName: widget.roomName,
              applianceId: widget.id,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final String smallCaseTileType = widget.tileType.toLowerCase();
    return Container(
      margin: const EdgeInsets.all(4),
      
      decoration: BoxDecoration(
          color: state ? const Color(0xFF87CEEB) : const Color(0xFFE6E6E6),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade600,
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(2, 2),
            ),
            const BoxShadow(
              color: Color(0xffffffff),
              blurRadius: 2,
              offset: Offset(-2, -2),
            )
          ]),
      child: GestureDetector(
        // onLongPress: () => {
        //   print('long press'),
        //   HapticFeedback.vibrate(),
        //   // give vibration feedback
        // },
        onTap: () => widget.appliance
            ? _showApplianceModal(context)
            : _navigateToRoomPage(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 8),
          // padding: const EdgeInsets.all(0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      // alignment: Alignment.topLeft,
                      // fit: FlexFit.tight,
                      child: Image.asset(
                        '${widget.appliance ? applianceImagePath : roomImagePath}/$smallCaseTileType${state ? 'true' : 'false'}.png',
                        // height: MediaQuery.sizeOf(context).height * 0.10,
                        // fit: BoxFit.contain,
                      ),
                    ),

                    // longer names will be cut off
                    Flexible(
                      child: Text(
                        widget.tileName.length > 7
                            ? '${widget.tileName.substring(0, 7)}...'
                            : widget.tileName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          height: 0.06,
                          letterSpacing: -0.54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                  onTap: onPowerTap,
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
        ),
      ),
    );
  }
}
