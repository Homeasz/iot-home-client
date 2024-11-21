import 'package:flutter/material.dart';
import 'package:homeasz/components/routine_tile.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:provider/provider.dart';

class RoutineWindow extends StatefulWidget {
  const RoutineWindow({super.key});

  @override
  State<RoutineWindow> createState() => _RoutineWindowState();
}

class _RoutineWindowState extends State<RoutineWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(child: Consumer<DataProvider>(
            builder: (context, dataProvider, child) => GridView.builder(
              padding: const EdgeInsets.only(
                top: 20,
                left: 5,
                right: 5,
                bottom: 40
              ),
                gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
              itemCount: dataProvider.routines.length,
              itemBuilder: (context, index) {
                final routine = dataProvider.routines[index];
                return RoutineTile(
                  routine: routine,
                  
                );
              }
            )
          ))
        ],
        )
    );
  }
}
