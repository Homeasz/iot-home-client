import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homeasz/components/qr_scanner.dart';
import 'package:homeasz/components/text_input.dart';
import 'package:homeasz/services/esp_service.dart';
import 'package:wifi_iot/wifi_iot.dart';

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
  String _connectionStatus = '';
  bool _isConnected = false;
  bool _scanQRPressed = false;

  // esp hotspot info variable
  String _ip = '';

  void ssidPassword(String value) async {
    setState(() {
      _ssidPassword = value;
    });

    // start loading circle
    showDialog(
        context: context,
        builder: (context) => const SizedBox(height: 300, width: 300, child: CircularProgressIndicator()));
    if(!(await WiFiForIoTPlugin.isEnabled())){
      print("#################### wifi is disabled");
      WiFiForIoTPlugin.setEnabled(true,
                  shouldOpenSettings: true);
                  print("#################### wifi is enabled");
    }
    await connect();
  }

  @override
  void initState() {
    super.initState();
  }

  void sendSSIDPasswordToESP() async {
    final ssid = ssidController.text;
    final password = passwordController.text;
    await espService.status();
    bool connected = await espService.addESP(ssid, password);
    if (connected) {
      setState(() {
        _connectionStatus = 'Sent Creds to ESP';
      });
      Navigator.pop(context, true);
    } else {
      setState(() {
        _connectionStatus = 'Failed to send Creds to ESP';
      });
    }
  }

  Future<bool> connect() async {
    final qrData = json.decode(_ssidPassword);
    final ssid =  qrData["SSID"];
    final password = qrData["PASSWORD"];
    print("#####################################   SSID: $ssid");
    print("#####################################   PASSWORD: $password");
    bool? connected = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      joinOnce: true,
      security: NetworkSecurity.WPA,
    );

    // create a timer to wait for the connection to be established
    // bool connected =  Timer(const Duration(seconds: 10), () => true) as bool;
    if (connected == true) {
      setState(() {
        _connectionStatus = 'Connected to $ssid';
      });
      setState(() {
        _isConnected = true;
      });
      setState(() {
        _scanQRPressed = false;
      });

      // get esp hotspot ip
      String ip = (await WiFiForIoTPlugin.getIP())!;
      await WiFiForIoTPlugin.forceWifiUsage(true);
      setState(() {
        _ip = ip;
      });

      await espService.status();
      ssidController.clear();
      passwordController.clear();
    } else {
      setState(() {
        _connectionStatus = 'Failed to connect to $ssid';
      });
      setState(() {
        _isConnected = false;
      });
    }
    return connected;
  }

  Widget showQR(BuildContext context) {
    return _scanQRPressed
        ? Container(
            height: 150,
            width: 150,
            child: QRScanner(
              callback: ssidPassword,
            ),
          )
        : GestureDetector(
            onTap: () {
              setState(() {
                _scanQRPressed = true;
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
              if (_isConnected) Text('Connected to $_ip'),
              if (_isConnected)
                Text(
                  _ssidPassword,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              if (_isConnected)
                Text(
                  _connectionStatus,
                ),
              const SizedBox(height: 10),
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
              TextInput(input: ssidController, hintText: 'SSID'),
              const SizedBox(height: 20),
              TextInput(input: passwordController, hintText: 'Password'),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: connect,
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
      ),
    );
  }
}
