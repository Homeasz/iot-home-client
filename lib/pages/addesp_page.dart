import 'package:flutter/material.dart';
import 'package:homeasz/components/my_camera.dart';
import 'package:homeasz/components/my_textfield.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:camera/camera.dart';

class AddESPPage extends StatefulWidget {
  const AddESPPage({super.key});

  @override
  State<AddESPPage> createState() => _AddESPPageState();
}

class _AddESPPageState extends State<AddESPPage> {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late List<CameraDescription> cameras;
  CameraDescription? firstCamera;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      firstCamera = cameras.first;
    }
    setState(() {
      isCameraInitialized = true;
    });
  }

  void connect() async {
    final ssid = ssidController.text;
    final password = passwordController.text;
    bool? connected = await WiFiForIoTPlugin.connect(ssid, password:password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add ESP'),
      ),
      body: Center(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isCameraInitialized && firstCamera != null)
                    MyCamera(camera: firstCamera!)
                  else
                    const CircularProgressIndicator(),

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
                  MyTextField(
                    controller: ssidController,
                    hintText: 'SSID',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: connect,
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
        ),
      ),
    );
  }
}
