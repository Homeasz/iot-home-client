import 'package:flutter/material.dart';
import 'package:homeasz/components/base_tile.dart';
import 'package:homeasz/models/routine_model.dart';
import 'package:homeasz/utils/image_paths.dart';

class RoutineTile extends StatelessWidget {
  final RoutineCloudResponse routine;
  final void Function(BuildContext, int, Type)? deleteCallback;

  const RoutineTile({
    super.key,
    required this.routine,
    this.deleteCallback,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTile(
      tileName: routine.name,
      tileType: routine.type,
      initialState: false,
      imagePath: routineImagePath,
      onTap: () =>
          Navigator.pushNamed(context, '/editRoutine', arguments: routine.id),
      onLongPress: (deleteCallback != null)
          ? () => deleteCallback!(context, routine.id, RoutineCloudResponse)
          : null,
      onPowerTap: () {},
    );
  }
}
