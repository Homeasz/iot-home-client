import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final ThemeData customTheme = ThemeData(
  primaryColor: const Color(0xFF6F35A5),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 202, 189, 168),
    shadowColor: Colors.black,
    scrolledUnderElevation: 5,
  ),
  secondaryHeaderColor: const Color(0xFFF1E6FF),
  scaffoldBackgroundColor: const Color(0xFFF8F8F8),
  fontFamily: 'Roboto',
  textTheme: const TextTheme(
      headlineLarge: TextStyle(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
      bodyLarge: TextStyle(color: Colors.black54, fontSize: 16),
      bodySmall: TextStyle(color: Colors.black, fontSize: 12)),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF6F35A5),
    textTheme: ButtonTextTheme.primary,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Color(0xFF6F35A5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Color(0xFF6F35A5)),
    ),
  ),
);


final ThemeData lightTheme = customTheme.copyWith(
  primaryColor: Color.fromARGB(255, 202, 189, 168),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 202, 189, 168),
    shadowColor: Colors.black,
    scrolledUnderElevation: 5,
  ),
  scaffoldBackgroundColor: const Color(0xFFF8F8F8),
  secondaryHeaderColor: const Color(0xFFF1E6FF),
  textTheme: const TextTheme(
      headlineLarge: TextStyle(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
      bodyLarge: TextStyle(color: Colors.black54, fontSize: 16),
      bodySmall: TextStyle(color: Colors.black, fontSize: 12)),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Color(0xFFBB86FC)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Color(0xFFBB86FC)),
    ),
  ),
);

final ThemeData darkTheme = customTheme.copyWith(
  primaryColor: const Color(0xFFBB86FC),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 48, 30, 66),
    shadowColor: Colors.black,
    scrolledUnderElevation: 5,
    actionsIconTheme: IconThemeData(color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Color.fromARGB(255, 181, 169, 169), fontSize: 20, fontWeight: FontWeight.bold),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFFBB86FC),
    selectionColor: Color(0xFFBB86FC),
    selectionHandleColor: Color(0xFFBB86FC),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  secondaryHeaderColor: const Color(0xFF1F1F1F),
  textTheme: const TextTheme(
      headlineLarge: TextStyle(
          color: Color.fromARGB(255, 181, 169, 169), fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          color: Color.fromARGB(255, 181, 169, 169), fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: Color.fromARGB(255, 181, 169, 169), fontSize: 18, fontWeight: FontWeight.normal),
      bodyLarge: TextStyle(color: Color.fromARGB(255, 181, 169, 169), fontSize: 16),
      bodyMedium: TextStyle(color: Color.fromARGB(255, 181, 169, 169),fontSize: 14),
      bodySmall: TextStyle(color: Color.fromARGB(255, 181, 169, 169), fontSize: 12),
      titleLarge: TextStyle(color: Color.fromARGB(255, 181, 169, 169), fontSize: 24, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Color.fromARGB(255, 181, 169, 169), fontSize: 20, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(color: Color.fromARGB(255, 181, 169, 169), fontSize: 18, fontWeight: FontWeight.normal),
      labelLarge: TextStyle(color: Color.fromARGB(255, 181, 169, 169), fontSize: 16),
      labelMedium: TextStyle(color: Color.fromARGB(255, 181, 169, 169), fontSize: 14),
      labelSmall: TextStyle(color: Color.fromARGB(255, 181, 169, 169), fontSize: 12),
      displayLarge: TextStyle(color: Color.fromARGB(255, 181, 169, 169), fontSize: 24, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Color.fromARGB(255, 181, 169, 169), fontSize: 20, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: Color.fromARGB(255, 181, 169, 169), fontSize: 18, fontWeight: FontWeight.normal),
      ),
      
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Color(0xFFBB86FC)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Color(0xFFBB86FC)),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
);
