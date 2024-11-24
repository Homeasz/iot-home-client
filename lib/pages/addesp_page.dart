import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homeasz/components/loading.dart';
import 'package:homeasz/components/qr_scanner.dart';
import 'package:homeasz/components/text_input.dart';
import 'package:homeasz/services/esp_service.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:homeasz/utils/request_permissions.dart';

class AddESPPage extends StatefulWidget {
  const AddESPPage({super.key});

  @override
  State<AddESPPage> createState() => _AddESPPageState();
}

class _AddESPPageState extends State<AddESPPage> {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final EspService espService = EspService();
  String _ssidPassword = '';
  String? EspSsid;
  String? _connectionStatus;
  bool _isConnected = false;
  bool _scanQRPressed = false;

  void ssidPassword(String value) async {
    setState(() {
      _ssidPassword = value;
    });

    // start loading circle
    loading(context);

    if (!(await WiFiForIoTPlugin.isEnabled())) {
      WiFiForIoTPlugin.setEnabled(true, shouldOpenSettings: true);
    }
    await connect();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  void sendSSIDPasswordToESP() async {
    final ssid = ssidController.text;
    final password = passwordController.text;
    await espService.status();
    await espService.addESP(ssid, password);
    loading(context);
    final phone_reconnected = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      joinOnce: false,
      security: NetworkSecurity.WPA,
    );
    // await WiFiForIoTPlugin.disconnect();
    bool Esp_connected = false;

    //TODO: add additional cloud call confirmation
    if (phone_reconnected && EspSsid != null) {
      final hostname = "Homeasz-${EspSsid!.substring(12)}";
      int retry_mdns_resolve = 3;
      for (int i = 0; i < retry_mdns_resolve; i++) {
        Esp_connected = await espService.mDnsResolve(hostname);
        if (Esp_connected) break;
      }
    }
    Navigator.pop(context);
    _connectionStatus = Esp_connected
        ? "Successfully added the kit"
        : "Wifi Credentials seem to be incorrect, please try again!";

    // bool connected =
    // if (connected) {
    //   setState(() {
    //     _connectionStatus = 'Sent Creds to ESP';
    //   });
    //   Future.delayed(Duration(seconds: 5),(){Navigator.pop(context, true);});
    // } else {
    //   setState(() {
    //     _connectionStatus = 'Failed to send Creds to ESP';
    //   });
    // }
  }

  Future<bool> connect() async {
    final qrData = json.decode(_ssidPassword);
    final ssid = qrData["SSID"];
    EspSsid = ssid;
    final password = qrData["PASSWORD"];
    bool? connected = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      joinOnce: true,
      security: NetworkSecurity.WPA,
    );
    // connected = false;
    // create a timer to wait for the connection to be established
    // bool connected =  Timer(const Duration(seconds: 10), () => true) as bool;
    if (connected) {
      // setState(() {
      //   _connectionStatus = 'Connected to $ssid';
      //   _isConnected = true;
      //   _scanQRPressed = false;
      // });
      // setState(() {
      //   _isConnected = true;
      // });
      // setState(() {
      //   _scanQRPressed = false;
      // });

      await WiFiForIoTPlugin.forceWifiUsage(true);
      setState(() {
        _connectionStatus = 'Connected to $ssid';
        _isConnected = true;
        _scanQRPressed = false;
      });
      await espService.status();
      ssidController.clear();
      passwordController.clear();
    } else {
      setState(() {
        _connectionStatus = 'Failed to connect to $ssid';
        _scanQRPressed = false;
        _isConnected = false;
      });
    }
    return connected;
  }

  Widget showQR(BuildContext context) {
    return _scanQRPressed
        ? Container(
            height: 300,
            width: 300,
            child: QRScanner(
              callback: ssidPassword,
            ),
          )
        : GestureDetector(
            onTap: () async {
              if (_isConnected) {
                await WiFiForIoTPlugin.disconnect();
              }
              //Needed to do mdns resolve
              requestPermissions();
              setState(() {
                _scanQRPressed = true;
                _connectionStatus = null;
              });
            },
            child: Container(
              height: 50,
              width: 150,
              padding: const EdgeInsets.all(10),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(4, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.qr_code,
                    color: Colors.black,
                  ),
                  Text(
                    'Scan QR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0.06,
                      letterSpacing: -0.54,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7F8FF),
      appBar: AppBar(
        title: const Text('Add Device'),
        backgroundColor: const Color(0xFFE7F8FF),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Setup new Homeasz kit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    // height: 0.06,
                    // letterSpacing: -0.54,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              showQR(context),
              const SizedBox(height: 10),
              if (_connectionStatus != null)
                Text(
                  _connectionStatus!,
                ),
              const SizedBox(height: 10),
              Visibility(
                visible: _isConnected,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Connect kit to Wi-Fi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyTextInput(input: ssidController, hintText: 'SSID'),
                    const SizedBox(height: 20),
                    MyTextInput(input: passwordController, hintText: 'Password'),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: sendSSIDPasswordToESP,
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(10),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 2,
                                offset: Offset(2, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: const Text(
                            'Add Kit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
