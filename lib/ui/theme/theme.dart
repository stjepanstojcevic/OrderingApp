import 'package:flutter/material.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  useMaterial3: true,
);

class AppTheme {
  static const TextStyle headingTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle dataTableHeaderTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  static const TextStyle totalPriceTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle confirmOrderButtonTextStyle = TextStyle(
    fontSize: 24,
  );

  static const TextStyle orderConfirmedTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle orderAgainButtonTextStyle = TextStyle(
    fontSize: 20,
  );
}

const double defaultPadding = 16.0;
Color mainColor = Colors.blue;
