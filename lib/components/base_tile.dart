import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeasz/utils/image_paths.dart';

// if onPowertap is not provided, the power button will not be shown

class BaseTile extends StatefulWidget {
  const BaseTile({
    super.key,
    required this.tileName,
    required this.tileType,
    required this.initialState,
    required this.onTap,
    required this.onLongPress,
    this.imagePath,
    this.onPowerTap,
  });

  final String tileName;
  final String tileType;
  final bool initialState;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String? imagePath;
  final VoidCallback? onPowerTap;

  @override
  State<BaseTile> createState() => _BaseTileState();
}

class _BaseTileState extends State<BaseTile> {
  late bool state;

  @override
  void initState() {
    super.initState();
    state = widget.initialState;
  }

  void toggleState() {
    setState(() {
      state = !state;
    });
    if (widget.onPowerTap != null) {
      widget.onPowerTap!();
    }
  }

  String shortenTileName(String tileName) {
    return tileName.length > 7 ? '${tileName.substring(0, 7)}...' : tileName;
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
          ),
        ],
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Image.asset(
                        '${widget.imagePath}/$smallCaseTileType${state ? 'true' : 'false'}.png',
                      ),
                    ),
                    Flexible(
                      child: Text(
                        shortenTileName(widget.tileName),
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
              if (widget.onPowerTap != null)
                InkWell(
                    onTap: toggleState,
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
