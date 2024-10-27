import 'package:flutter/material.dart';
import 'package:homeasz/components/appliance_button.dart';
import 'package:homeasz/components/modal_sheets/add_to_home_favourites.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/image_paths.dart';
// ignore: unused_import
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class HomeWindowFavouriteSwitches extends StatefulWidget {
  const HomeWindowFavouriteSwitches({super.key});

  @override
  State<HomeWindowFavouriteSwitches> createState() =>
      _HomeWindowFavouriteSwitchesState();
}

class _HomeWindowFavouriteSwitchesState
    extends State<HomeWindowFavouriteSwitches> {
  final ScrollController _scrollController = ScrollController();

  void _showAddToHomeDialog(BuildContext context) {
    showDialog(
        context: context,
        useSafeArea: true,
        // backgroundColor: const Color(0xFFE7F8FF),
        builder: (context) {
          return const Dialog(
              backgroundColor: Color(0xFFE7F8FF), child: AddToHomeFavourites());
        });
  }

  @override
  Widget build(BuildContext context) {
    List<PowerSwitch> favouriteSwitches =
        Provider.of<DataProvider>(context).homePageSwitches;
    return SizedBox(
      height: 96,
      child: Scrollbar(
        trackVisibility: false,
        thumbVisibility: false,
        thickness: 0, // hide scrollbar
        // hide scrollbar
        controller: _scrollController,
        scrollbarOrientation: ScrollbarOrientation.bottom,
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: favouriteSwitches.length + 1,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 20);
          },
          itemBuilder: (context, index) {
            if (favouriteSwitches.isEmpty) {
              return noFavorites(context);
            }
            return someFavorites(index, favouriteSwitches, context);
          },
        ),
      ),
    );
  }

  Widget noFavorites(BuildContext context) {
    return InkWell(
      onTap: () => _showAddToHomeDialog(context),
      splashColor: Colors.pink,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        height: 30,
        child: Image.asset(addImagePath),
      ),
    );
  }

  Padding someFavorites(
      int index, List<PowerSwitch> favouriteSwitches, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: (index == favouriteSwitches.length)
            ? InkWell(
                onTap: () => _showAddToHomeDialog(
                    context), // Provider.of<DataProvider>(context, listen: false).addSwitchToHomePage(4),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset(addImagePath),
                ),
              )
            : ApplianceButton(
                switchId: favouriteSwitches[index].id,
                applianceName: favouriteSwitches[index].name,
                type: favouriteSwitches[index].type,
                roomName: favouriteSwitches[index].roomName,
                state: favouriteSwitches[index].state,
              ));
  }
}
