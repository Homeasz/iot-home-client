import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  PermissionStatus status = await Permission.location.request();
  if (!status.isGranted) {
    // Handle permission denied case
    print("Location permission is required for mDNS");
  }
}
