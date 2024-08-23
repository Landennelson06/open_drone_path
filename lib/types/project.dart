import 'package:flutter_map/flutter_map.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

import 'CircleMarkers.dart';
import 'generateOptions.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project extends HiveObject {
  @HiveField(0)
  String name = 'NOT SET';
  @HiveField(1)
  Map map = {
    "long": 0,
    "lat": 0,
  };
  @HiveField(2)
  DateTime dateCreated = DateTime.now();
  @HiveField(3)
  DateTime dateModified = DateTime.now();
  @HiveField(4)
  GenerateOptions generateOptions = GenerateOptions();
  @HiveField(5)
  CircleMarkers? currentCircle;
  @HiveField(6)
  List<CircleMarkers> circleMarkers = [];
  Project(this.name);
  Project.all(this.name, this.dateCreated, this.dateModified);
}

