import 'package:flutter/material.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

// const kPrimaryColor = Colors.green;
// const kPrimaryLightColor = Colors.green;
// const kPrimaryColor = Color(0x00a7a5);
// const kPrimaryColor = Color(0x00dbd9);
// const kPrimaryColor = Color(0x005958);
// const kPrimaryColor = Color(0xe29527);
// const kPrimaryColor = Color(0xbd6200);
// const kPrimaryColor = Color(0x5d3100);

// const kPrimaryColor = Color(0x005958);
// const kPrimaryLightColor = Color(0xbd6200);

MaterialColor kPrimaryColor = createMaterialColor(Color(0xFF005958));
MaterialColor kPrimaryLightColor = createMaterialColor(Color(0xFF00a7a5));
MaterialColor kSecondaryColor = createMaterialColor(Color(0xFF5d3100));
MaterialColor kSecondaryLightColor = createMaterialColor(Color(0xFFe29527));
// MaterialColor(0x005958FF, color);
// MaterialColor kPrimaryLightColor = MaterialColor(0x005958FF, color);
