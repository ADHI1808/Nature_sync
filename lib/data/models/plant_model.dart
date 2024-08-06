import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'plant_model.g.dart';

@HiveType(typeId: 1)
class Plant extends HiveObject {
  @HiveField(0)
  Uint8List image;
  @HiveField(1)
  Map<String, String>? variables;
  @HiveField(2)
  String? aiTips;

  Plant(this.image, this.variables, this.aiTips);

  void update(String title, String newTitle) {
    Plant plantDetails = Hive.box('plants').get(title);
    Hive.box('plants').delete(title);
    Hive.box('plants').put(newTitle, plantDetails);
  }

  void addVariable(String variable, String value) =>
      variables!.addAll({variable: value});
  void removeVariable(String key) => variables!.remove(key);
}
