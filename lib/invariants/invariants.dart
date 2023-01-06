import 'package:flutter/material.dart';

class Invariants {
  static Map<int, Color> _generateSwatch(int r, int g, int b) {
    return {
      50: Color.fromRGBO(r, g, b, .1),
      100: Color.fromRGBO(r, g, b, .2),
      200: Color.fromRGBO(r, g, b, .3),
      300: Color.fromRGBO(r, g, b, .4),
      400: Color.fromRGBO(r, g, b, .5),
      500: Color.fromRGBO(r, g, b, .6),
      600: Color.fromRGBO(r, g, b, .7),
      700: Color.fromRGBO(r, g, b, .8),
      800: Color.fromRGBO(r, g, b, .9),
      900: Color.fromRGBO(r, g, b, 1),
    };
  }

  static Map<int, double> iflcToRecommendedSizeOfWires = {
    25: 2.0,
    30: 3.5,
    40: 5.5,
    55: 8.0,
    75: 14,
    95: 22,
    115: 30,
    130: 38,
    150: 50,
    170: 60,
    205: 80,
    240: 100,
    285: 125,
    320: 150,
    345: 175,
    360: 200,
    425: 250,
    490: 325,
    530: 375,
    535: 400,
    595: 500
  };

  static List<int> mainProtectiveDevice = [
    15,
    20,
    25,
    30,
    35,
    40,
    45,
    50,
    60,
    70,
    80,
    90,
    100,
    110,
    125,
    150,
    175,
    200,
    225,
    250,
    300,
    350,
    400,
    450,
    500,
    600,
    700,
    800,
    1000,
    1200,
    1600,
    2000,
    2500,
    3000,
    4000,
    5000,
    6000
  ];

  // colors
  static MaterialColor get navBarColor =>
      MaterialColor(0xFF333333, _generateSwatch(0x33, 0x33, 0x33));

  static MaterialColor get yellow =>
      MaterialColor(0xFFFFC52F, _generateSwatch(0xFF, 0xC5, 0x2F));

  // paths
  static String get iconPath => 'images/icon.png';

  // sizes
  static double get fontSizeSmall => 10.0;

  static double get fontSizeMedium => 20.0;

  static double get formWidth => 150.0;

  static double get verticalSpacing => 30.0;
}
