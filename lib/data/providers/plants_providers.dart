import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final plantsProvider = StateProvider<Map>((ref) {
  return Hive.box('plants').toMap();
});
