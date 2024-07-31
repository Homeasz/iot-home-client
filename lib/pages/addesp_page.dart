import 'package:flutter/material.dart';
import 'package:homeasz/components/my_textfield.dart';
import 'package:homeasz/components/qr_scanner.dart';
import 'package:homeasz/services/esp_service.dart';
import 'package:wifi_iot/wifi_iot.dart';
import "dart:convert";
import 'testWifiPrefix.dart';


class AddESPPage extends StatefulWidget {
  const AddESPPage({super.key});

  @override
  State<AddESPPage> createState() => _AddESPPageState();
}

class _AddESPPageState extends State<AddESPPage> {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final EspService espService = EspService();
  String _ssid = '';
  String _password = '';
  String _connectionStatus = '';
  bool _isConnected = false;

  // esp hotspot info variable
  String _ip = '';


  void parseQR(String QrPayload) async {
    final parsedQR = jsonDecode(QrPayload);
    _ssid = parsedQR['SSID'] as String;
    _password = parsedQR['PASSWORD'] as String;
    connect();
    // start loading circle
    // showDialog(context: context, builder: (context) => const CircularProgressIndicator());

    // await connect();
  }

  @override
  void initState() {
    super.initState();
  }

  void connectToNearestESP() {
    
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
    final ssid = _ssid;
    final password = _password;
    bool? connected = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      joinOnce: false,
      security: NetworkSecurity.WPA,
    );
    if (connected == true) {
      setState(() {
        _connectionStatus = 'Connected to $ssid';
      });
      setState(() {
        _isConnected = true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add ESP'),
      ),
      body: _isConnected ? _sendCredsToESP(context) : _connectToESP(context),
    );
  }

  Center _sendCredsToESP(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Connected to ESP'),
          Text('IP: $_ip',
              style: Theme.of(context).textTheme.bodyLarge
          ),
          const SizedBox(height: 20),
          // get wifi creds for ESP
          TextField(
            controller: ssidController,
            decoration: const InputDecoration(
              hintText: 'SSID',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          GestureDetector(
            onTap: sendSSIDPasswordToESP,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Send Creds to ESP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Center _connectToESP(BuildContext context) {
    return Center(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 300,
                  width: 300,
                  child: QRScanner(
                    callback: parseQR,
                  )),

              // horizontal divider with or text and border padding
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _connectionStatus,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              MyTextField(
                controller: ssidController,
                hintText: 'SSID',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: (){ ConnectWifiPrefix(); /*_ssid = ssidController.text; _password = passwordController.text; connect();*/},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Connect',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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
