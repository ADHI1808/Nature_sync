import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/setting_logic/setting_handler.dart';
import '../../presentation/themes/dark_theme.dart';
import '../../presentation/themes/light_theme.dart';
import '../models/themes_model.dart';




final themesProvider = StateProvider<Themes>((ref) {
  SettingsHandler settingsHandler = SettingsHandler();
  String theme = settingsHandler.getValue('app_theme') ?? "system";

  switch (theme) {
    case "light":
      return LightTheme();
    case "dark":
      return DarkTheme();
    default:
      {
        Brightness systemBrightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;

        return systemBrightness == Brightness.light
            ? LightTheme()
            : DarkTheme();
      }
  }
});
