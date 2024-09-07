import 'package:flutter/material.dart';

class ApplianceButton extends StatefulWidget {
  const ApplianceButton({
    super.key,
    required this.index,
    required this.applianceName,
    required this.applianceState,
  });

  final int index;
  final String applianceName;
  final bool applianceState;

  @override
  State<ApplianceButton> createState() => _ApplianceButtonState();
}

class _ApplianceButtonState extends State<ApplianceButton> {
  
  // change state of appliance
  void onTap(int index) {
    print('Appliance $index is turned ${widget.applianceState ? 'off' : 'on'}');

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(widget.index);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.applianceState ? const Color(0xFFE6F8FF) : const Color(0xFFE6F8FF),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 100,
        child: Column(
          children: [
            
            Icon(
              widget.applianceState ? Icons.lightbulb : Icons.lightbulb_outline,
              color: widget.applianceState ? const Color(0xFF00BFA6) : Colors.grey,
              size: 30,
            ),
            Text(
              widget.applianceName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )
    );
  }
}