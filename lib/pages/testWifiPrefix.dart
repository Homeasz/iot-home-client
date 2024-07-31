// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectWifiPrefix extends StatefulWidget {
  const ConnectWifiPrefix({super.key});

  @override
  State<ConnectWifiPrefix> createState() => _ConnectWifiPrefixState();
}

class _ConnectWifiPrefixState extends State<ConnectWifiPrefix> {
  static const MethodChannel methodChannel =
      MethodChannel('wifi_configuration');
  String _connectResult = 'unknown';

  Future<void> _connectWifiPrefix() async {
      
    log('qwerty _connectWifiPrefix');
    String connectResult;
    try {
      final int? result = await methodChannel.invokeMethod('configureWifi',{'ssid':'ESP','passphrase':'an2ocean'});
      connectResult = 'Connect status: $result%.';
      log('qwerty connectResult: $connectResult');
    } on PlatformException {
      connectResult = 'Failed to get Connect status.';
    }
    setState(() {
      _connectResult = connectResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_connectResult, key: const Key('connect wifi label')),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _connectWifiPrefix,
                  child: const Text('Refresh'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}