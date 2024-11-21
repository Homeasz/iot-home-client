import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homeasz/components/add_button.dart';
import 'package:homeasz/components/switch_tile.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:homeasz/utils/image_paths.dart';
import 'package:provider/provider.dart';

class RoomPage extends StatefulWidget {
  const RoomPage(
      {super.key,
      required this.roomName,
      required this.roomType,
      required this.roomId});

  final String roomName;
  final String roomType;
  final int roomId;

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool state = false;
  late DataProvider _dataProvider;

  void onPowerTap() {
    setState(() {
      state = !state;
    });
  }

  @override
  void initState() {
    super.initState();
    _dataProvider = Provider.of<DataProvider>(context, listen: false);
    _dataProvider.getSwitches(roomId: widget.roomId);
  }

  @override
  void dispose() {
    _dataProvider.clearSwitches();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final smallRoomType = widget.roomType.toLowerCase();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFE6F8FF),
          toolbarHeight: 30,
          // on scroll up dont change the appbar
          scrolledUnderElevation: 0,
        ),
        backgroundColor: const Color(0xFFE6F8FF),
        floatingActionButton: const AddButton(
          window: 3,
        ),
        body: Center(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 90,
                    width: MediaQuery.sizeOf(context).width,
                    color: const Color(0xFFE6F8FF),
                  ),
                  Expanded(
                    child: Container(
                        // height should be to the bottom of the screen
                        // width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFE6F8FF),
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              widget.roomName,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Expanded(
                              child: Consumer<DataProvider>(
                                builder: (BuildContext context,
                                    DataProvider value, Widget? child) {
                                  return GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                    ),
                                    itemCount: value.switches.length,
                                    itemBuilder: (context, index) {
                                      final switchModel = value.switches[index];
                                      return SwitchTile(
                                        // index: index,
                                        powerSwitch: switchModel,
                                        roomName: widget.roomName,
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              ),
              Positioned(
                top: -15,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  height: 160,
                  width: MediaQuery.sizeOf(context).width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
                      Image(
                          image: AssetImage(
                              '$roomImagePath/$smallRoomType${state ? 'true' : 'false'}.png')),
                      Column(
                        children: [
                          InkWell(
                              onTap: onPowerTap,
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
                                        child: SvgPicture.asset(
                                            width: 20, powerImage)),
                                  ))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
