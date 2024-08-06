
import 'package:my_tflit_app/data/models/themes_model.dart';
import 'package:flutter/material.dart';

class LightTheme extends Themes {
  @override
  int get id => 1;

  @override
  Color get primaryColor => const Color(0xFF00A170);

  @override
  Color get secondaryColor => const Color.fromARGB(255, 216, 216, 216);

  @override
  Color get focusColor => const Color.fromARGB(255, 212, 204, 204);

  @override
  Color get backgroundColor => const Color(0xFFEDEDED);

  @override
  Color get textColor => const Color(0xFF36454F);
}
