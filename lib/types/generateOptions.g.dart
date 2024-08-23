// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generateOptions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GenerateOptionsAdapter extends TypeAdapter<GenerateOptions> {
  @override
  final int typeId = 1;

  @override
  GenerateOptions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GenerateOptions()
      ..flightAreaOffset = fields[0] as bool
      ..flightDirection = fields[1] as FlightDirection
      ..waypointOptions = fields[3] as WaypointOptions
      ..cameraAngle = fields[4] as int
      ..altitude = fields[5] as int
      ..spaceBetweenLines = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, GenerateOptions obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.flightAreaOffset)
      ..writeByte(1)
      ..write(obj.flightDirection)
      ..writeByte(3)
      ..write(obj.waypointOptions)
      ..writeByte(4)
      ..write(obj.cameraAngle)
      ..writeByte(5)
      ..write(obj.altitude)
      ..writeByte(6)
      ..write(obj.spaceBetweenLines);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenerateOptionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FlightDirectionAdapter extends TypeAdapter<FlightDirection> {
  @override
  final int typeId = 2;

  @override
  FlightDirection read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FlightDirection.northSouth;
      case 1:
        return FlightDirection.eastWest;
      case 2:
        return FlightDirection.both;
      default:
        return FlightDirection.northSouth;
    }
  }

  @override
  void write(BinaryWriter writer, FlightDirection obj) {
    switch (obj) {
      case FlightDirection.northSouth:
        writer.writeByte(0);
        break;
      case FlightDirection.eastWest:
        writer.writeByte(1);
        break;
      case FlightDirection.both:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlightDirectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WaypointOptionsAdapter extends TypeAdapter<WaypointOptions> {
  @override
  final int typeId = 3;

  @override
  WaypointOptions read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WaypointOptions.noAction;
      case 1:
        return WaypointOptions.takePicture;
      default:
        return WaypointOptions.noAction;
    }
  }

  @override
  void write(BinaryWriter writer, WaypointOptions obj) {
    switch (obj) {
      case WaypointOptions.noAction:
        writer.writeByte(0);
        break;
      case WaypointOptions.takePicture:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaypointOptionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
