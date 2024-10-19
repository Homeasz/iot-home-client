import 'package:flutter/material.dart';
import 'package:homeasz/components/appliance_button.dart';
import 'package:homeasz/components/modal_sheets/add_to_home_favourites.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/image_paths.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class HomeWindowFavouriteSwitches extends StatelessWidget {

  void _showAddToHomeDialog(BuildContext context){
    print("clicekd");
    showDialog(
        context: context,
        useSafeArea: true,
        // backgroundColor: const Color(0xFFE7F8FF),
        builder: (context) {
          return Dialog(
            backgroundColor: Color(0xFFE7F8FF),
            child: AddToHomeFavourites()
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<SwitchModel> favouriteSwitches =
        Provider.of<DataProvider>(context).HomePageSwitches;
    return SizedBox(
      height: 96,
      child: Scrollbar(
        thumbVisibility: false,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: favouriteSwitches.length + 1,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 20);
          },
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: (index == favouriteSwitches.length)
                    ? InkWell(
                      onTap: () =>_showAddToHomeDialog(context),// Provider.of<DataProvider>(context, listen: false).addSwitchToHomePage(4),
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
          },
        ),
      ),
    );
  }
}
