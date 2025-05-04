import 'package:flutter/material.dart';

const String BASE_URL =
    'https://homeasz-fwdse6dne5agarbc.centralindia-01.azurewebsites.net';
// 'http://ec2-3-109-126-105.ap-south-1.compute.amazonaws.com';
// const String BASE_URL =
//     'https://ec2-3-109-126-105.ap-south-1.compute.amazonaws.com';
// const String BASE_URL =
//     'https://ec2-3-109-126-105.ap-south-1.compute.amazonaws.com/';

// const String BASE_URL =
//     'http://localhost:8080';

// const String BASE_URL = 'https://iot-home-web.onrender.com';
// const String BASE_URL = 'https://iot-home-web-room-service.onrender.com';
// const String BASE_URL = 'https://iot-home-web-device-service.onrender.com';
const String ESP_URL = 'http://192.168.0.1';

const int homeWindow = 0;
const int roomsWindow = 1;
const int routinesWindow = 2;
const int addDeviceWindow = 3;

const int animationLoadingPos = 0;
const int animationHomePos = 1;
const int animationOthersPos = 2;

// const String tProfileImage = "assets/images/profile.jpg";
const String tFullName = "Full Name";
const String tEmail = "Email";
const String tPhoneNo = "Phone Number";
const String tPassword = "Password";
const String tEditProfile = "Edit Profile";
const String tJoined = "Joined ";
const String tJoinedAt = "12-12-2021";
const String tDelete = "Delete Account";

const String BALCONY = "balcony";

Color tPrimaryColor = Colors.amber[100]!;
Color tAccentColor = Colors.amber[300]!;
Color tDarkColor = Colors.black54;

List<String> roomNames = [
  "balcony",
  "bedroom",
  "door",
  "kitchen",
  "livingroom",
  "officedesk",
  "bathroom",
  "table"
];
List<String> applianceNames = [
  "ac",
  "airpurifier",
  "chandelier",
  "christmaslight",
  "cooking",
  "exhaustpipe",
  "fan",
  "heater",
  "ledtv",
  "lightbulb",
  "light",
  "lighting",
  "outdoor",
  "socket",
  "tablefan",
  "tablelamp",
  "walllamp",
  "waterpump"
];
