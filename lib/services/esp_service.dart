import 'dart:io';

import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class EspService {
  
  Future<bool> addESP(String ssid, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$ESP_URL/wifiConnect.json'),
        headers: {
          'Accept': 'application/json, text/javascript, /; q=0.01',
          'Connection': 'keep-alive',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'X-Requested-With': 'XMLHttpRequest',
          'my-connect-pwd': password,
          'my-connect-ssid': ssid,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (e) {
      // Handle network-related errors
      return false;
    } catch (e) {
      // Handle other types of errors
      return false;
    }
  }

  Future<void> status() async {
    try {
      final response = await http.get(Uri.parse('$ESP_URL/switchStatus'));
      if (response.statusCode == 200) {
      }
    } catch (e) {
    }
  }
}
