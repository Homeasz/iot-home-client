import 'package:flutter/material.dart';
import 'package:homeasz/components/base_tile.dart';
import 'package:homeasz/models/routine_model.dart';
import 'package:homeasz/utils/image_paths.dart';

class RoutineTile extends StatelessWidget {
  final Routine routine;

  const RoutineTile({
    super.key,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTile(
      tileName: routine.name,
      tileType: routine.type,
      initialState: false,
      imagePath: routineImagePath,
      onTap: () {},
      onLongPress: () {},
      onPowerTap: () {},
    );
  }
}
