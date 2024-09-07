import 'package:flutter/material.dart';

class ApplianceButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Appliance $index');
      },
      child: Card(
        child: Text(applianceName),
        
      ),
    );
  }
}