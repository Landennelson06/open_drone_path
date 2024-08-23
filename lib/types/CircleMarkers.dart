import 'package:flutter_map/flutter_map.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
part 'CircleMarkers.g.dart';
@HiveType(typeId: 4)
class CircleMarkers extends HiveObject{
  @HiveField(0)
  int displayOrder = 0;
  @HiveField(1)
  CircleMarker marker = new CircleMarker(point: LatLng(1, 1), radius: 1);
  @HiveField(2)
  String id = Uuid().v1();
  CircleMarkers(this.displayOrder, this.marker);
  CircleMarkers.justDisplayOrder(this.displayOrder);
}