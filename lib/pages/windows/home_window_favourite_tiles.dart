import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:homeasz/components/appliance_button.dart';
import 'package:homeasz/components/modal_sheets/add_to_home_favourites.dart';
import 'package:homeasz/components/room_tile.dart';
import 'package:homeasz/components/routine_tile.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/routine_model.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/image_paths.dart';
// ignore: unused_import
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class HomeWindowFavouriteTiles extends StatefulWidget {
  const HomeWindowFavouriteTiles({super.key});

  @override
  State<HomeWindowFavouriteTiles> createState() =>
      _HomeWindowFavouriteTilesState();
}

class _HomeWindowFavouriteTilesState extends State<HomeWindowFavouriteTiles> {
  // final ScrollController _scrollController = ScrollController();
  void deleteFavouriteCallback(BuildContext context, int id, Type runtimeType) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.deleteFavouriteTile(id, runtimeType);
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    log("$TAG - build: HomeWindowFavouriteTiles ${dataProvider.homeWindowFavouriteTiles.length}");
    return Expanded(
      child: Consumer<DataProvider>(
        builder: (context, dataProvider, child) => GridView.builder(
            padding:
                const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 40),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: dataProvider.homeWindowFavouriteTiles.length,
            itemBuilder: (context, index) {
              final tileInfo = dataProvider.homeWindowFavouriteTiles[index];
              // return BigTile(
              //     id: room.id,
              //     index: index,
              //     tileName: room.name,
              //     tileType: room.type
              //   );
              log("$TAG - build: HomeWindowFavouriteTiles ${tileInfo.runtimeType}");
              if (tileInfo.runtimeType == Room) {
                log("$TAG - build: HomeWindowFavouriteTiles RoomTile ROOM");
                return RoomTile(
                    room: tileInfo, deleteCallback: deleteFavouriteCallback);
              } else if (tileInfo.runtimeType == RoutineCloudResponse) {
                log("$TAG - build: HomeWindowFavouriteTiles RoomTile ROUTINEUI");
                return RoutineTile(
                    routine: tileInfo, deleteCallback: deleteFavouriteCallback);
              }
            }),
      ),
    );
  }

  String TAG = "HomeWindowFavouriteTiles";
}
