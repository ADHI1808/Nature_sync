import 'package:my_tflit_app/presentation/screens/dashboard/models/viewtype_model.dart';
import 'package:my_tflit_app/data/models/plant_model.dart';
import 'package:my_tflit_app/presentation/screens/dashboard/models/viewtype_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_tflit_app/app.dart';

import 'app.dart';
import 'data/models/plant_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Registering adapters
  Hive.registerAdapter(ViewTypeAdapter());
  Hive.registerAdapter(PlantAdapter());

  // Opening the databases
  await Hive.openBox('plants');
  await Hive.openBox('settings');
  await Hive.openBox('scoreBox');

  runApp(const ProviderScope(child: my_tflite_app()));
}
