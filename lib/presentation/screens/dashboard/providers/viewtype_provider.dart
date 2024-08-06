import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../logic/setting_logic/setting_handler.dart';
import '../models/viewtype_model.dart';

final viewTypeProvider = StateProvider<ViewType>((ref) {
  SettingsHandler settingsHandler = SettingsHandler();
  return settingsHandler.getValue('plants_viewtype') ?? ViewType.list;
});
