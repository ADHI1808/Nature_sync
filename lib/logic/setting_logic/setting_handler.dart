import 'package:hive/hive.dart';

class SettingsHandler {
  final settings = Hive.box("settings");

  bool isInitialized() => Hive.isBoxOpen('settings');
  dynamic getValue(String setting) => settings.get(setting);
  dynamic setValue(String setting, dynamic value) =>
      settings.put(setting, value);
}
