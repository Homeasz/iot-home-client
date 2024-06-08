import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

void httpErrorHandle({
  required BuildContext context,
  required http.Response response,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      final Map<String, dynamic> body = jsonDecode(response.body);
      showSnackBar(context, body['message']);
      break;
    case 401:
      showSnackBar(context, 'Unauthorized');
      break;

    default:
      final Map<String, dynamic> body = jsonDecode(response.body);
      showSnackBar(context, body['error']);
  }
}
