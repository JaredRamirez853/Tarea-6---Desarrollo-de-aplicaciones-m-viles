import 'package:flutter/material.dart';

ThemeData buildTheme(Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorSchemeSeed: const Color(0xFFC2410C),
    appBarTheme: const AppBarTheme(centerTitle: false),
  );
}
