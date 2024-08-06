import 'package:hive/hive.dart';

part 'viewtype_model.g.dart';

@HiveType(typeId: 0)
enum ViewType {
  @HiveField(0)
  grid,

  @HiveField(1)
  list,
}
