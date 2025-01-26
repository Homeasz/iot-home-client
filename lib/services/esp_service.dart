import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:multicast_dns/multicast_dns.dart';
import '../utils/constants.dart';

class EspService {
  Future<int> addESP(String ssid, String password, String deviceId) async {
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
          'deviceId': deviceId,
        },
      ).timeout(const Duration(seconds: 20));
      log("addESP: response - ${response.body}");

      return jsonDecode(response.body)["error"];
    } on TimeoutException catch (e) {
      // Handle timeout errors
      return 107;
    } catch (e) {
      // Handle other types of errors
      return 108;
    }
  }

//TODO: store this resolved ip for http comm. later
  Future<bool> mDnsResolve(String hostname) async {
    final MDnsClient client = MDnsClient(
      rawDatagramSocketFactory: (
        dynamic host,
        int port, {
        bool? reuseAddress,
        bool? reusePort,
        int? ttl,
      }) {
        return RawDatagramSocket.bind(
          host,
          port,
          reusePort: false,
          ttl: ttl!,
        );
      },
    );
    try {
      await client.start();
      await for (final IPAddressResourceRecord record
          in client.lookup<IPAddressResourceRecord>(
              ResourceRecordQuery.addressIPv4(hostname))) {
        print('Found address (${record.address}).');
        return true;
      }
    } catch (e) {
      print("Error resolving ip address");
    } finally {
      client.stop();
    }
    return false;
  }

  Future<bool> status() async {
    try {
      final response = await http.get(Uri.parse('$ESP_URL/switchStatus'));
      if (response.statusCode == 200) {return true;}
      return false;
    } catch (e) {
      return false;
    }
  }
}
