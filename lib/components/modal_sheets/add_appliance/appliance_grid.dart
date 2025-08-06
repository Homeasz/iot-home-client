import 'package:flutter/material.dart';
import 'package:homeasz/utils/constants.dart';
import 'package:homeasz/utils/image_paths.dart';

class ApplianceGrid extends StatefulWidget {
  final Function(int, String) onApplianceSelected;

  const ApplianceGrid({
    super.key,
    required this.onApplianceSelected,
  });

  @override
  State<ApplianceGrid> createState() => _ApplianceGridState();
}

class _ApplianceGridState extends State<ApplianceGrid> {
  int activeState = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 300,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: applianceNames.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (index == activeState) {
                    activeState = -1;
                  } else if (index != activeState) {
                    activeState = index;
                  }
                });
                widget.onApplianceSelected(index, applianceNames[index]);
              },
              child: Image(
                  image: AssetImage(
                      '$applianceImagePath/${applianceNames[index]}${activeState == index}.png')),
            );
          }),
    );
  }
}
