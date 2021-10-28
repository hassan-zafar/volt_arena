import 'package:flutter/material.dart';

class ColorsConsts {
  static Color black = Color(0xFF000000);
  static Color white = Color(0xFFFFFFFF);
  static Color title = Color(0xDD000000);
  static Color subTitle = Colors.orange;
  // Color(0x8A000000);
  static Color backgroundColor = Colors.orange; //grey shade 300
  static Color loginColor = Color(0xFFF7A000); // red 500
  // static Color signUpColor = Colors.white; // red 500

  static Color favColor = Color(0xFFF44336); // red 500
  static Color favBadgeColor = Color(0xFFE57373); // red 300

  static Color cartColor = Colors.white; //deep purple 600
  static Color cartBadgeColor = Color(0xFFBA68C8); //purple 300

  static Color gradiendFStart = Colors.yellow;
  static Color gradiendFEnd = Colors.yellow.shade900;
  static Color endColor = Colors.yellow; //purple 200
  static Color purple300 = Color(0xFFBA68C8); //purple 300
  static Color gradiendLEnd = Colors.yellow.shade900; //orange
  static Color gradiendLStart = Colors.yellow; //purple 500
  static Color starterColor = Colors.yellow.shade900; //purple 600
  static Color purple800 = Color(0xFF6A1B9A);
}

BoxDecoration backgroundColorBoxDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        // Color(0xff387A53),
        // Color(0xff8BE78B),

        Colors.black54,
        Colors.orange
        // Color(0xffFED5E3),
        // Color(0xff96B7BF),

        // Colors.green[100],
        // Colors.blue[200],
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomLeft,
    ),
  );
}
