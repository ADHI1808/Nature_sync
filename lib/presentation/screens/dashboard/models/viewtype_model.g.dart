// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viewtype_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ViewTypeAdapter extends TypeAdapter<ViewType> {
  @override
  final int typeId = 0;

  @override
  ViewType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ViewType.grid;
      case 1:
        return ViewType.list;
      default:
        return ViewType.grid;
    }
  }

  @override
  void write(BinaryWriter writer, ViewType obj) {
    switch (obj) {
      case ViewType.grid:
        writer.writeByte(0);
        break;
      case ViewType.list:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ViewTypeAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
