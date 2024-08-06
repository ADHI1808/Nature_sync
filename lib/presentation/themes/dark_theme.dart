import 'package:flutter/material.dart';
import 'package:my_tflit_app/data/models/themes_model.dart';

class DarkTheme extends Themes {
  @override
  int get id => 0;

  @override
  Color get primaryColor => const Color(0xFF00A170);

  @override
  Color get secondaryColor => const Color.fromARGB(255, 48, 45, 45);

  @override
  Color get focusColor => const Color.fromARGB(255, 34, 39, 36);

  @override
  Color get backgroundColor => const Color(0xFF121212);

  @override
  Color get textColor => const Color(0xEDEDEDED);
}
