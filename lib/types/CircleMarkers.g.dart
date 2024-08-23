// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CircleMarkers.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CircleMarkersAdapter extends TypeAdapter<CircleMarkers> {
  @override
  final int typeId = 4;

  @override
  CircleMarkers read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CircleMarkers(
      fields[0] as int,
      fields[1] as CircleMarker<Object>,
    )..id = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, CircleMarkers obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.displayOrder)
      ..writeByte(1)
      ..write(obj.marker)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CircleMarkersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
