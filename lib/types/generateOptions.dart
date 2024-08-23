import 'package:hive/hive.dart';

part 'generateOptions.g.dart';

@HiveType(typeId: 2)
enum FlightDirection {
  @HiveField(0)
  northSouth,
  @HiveField(1)
  eastWest,
  @HiveField(2)
  both
}

@HiveType(typeId: 3)
enum WaypointOptions {
  @HiveField(0)
  noAction,
  @HiveField(1)
  takePicture
}

@HiveType(typeId: 1)
class GenerateOptions extends HiveObject {
  @HiveField(0)
  bool flightAreaOffset = false;
  @HiveField(1)
  FlightDirection flightDirection = FlightDirection.northSouth;
  @HiveField(3)
  WaypointOptions waypointOptions = WaypointOptions.noAction;
  @HiveField(4)
  int cameraAngle = 0;
  @HiveField(5)
  int altitude = 0;
  @HiveField(6)
  int spaceBetweenLines = 0;
  @HiveField(7)
  int generateDistance = 0;
}
