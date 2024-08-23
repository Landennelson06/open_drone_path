import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:open_drone_path/types/project.dart';
import 'package:latlong2/latlong.dart' as latLng;
import '../pages/ProjectPage.dart';
import '../types/CircleMarkers.dart';
import '../types/MapButtons.dart';

class MapFull extends StatefulWidget {
  const MapFull({
    super.key,
    required this.project,
    required this.button,
  });

  final Project project;
  final MapButtons button;

  @override
  State<MapFull> createState() => _MapFullState();
}

class _MapFullState extends State<MapFull> {
  final LayerHitNotifier hitNotifier = ValueNotifier(null);
  MapController ctrl = MapController();
  final box = Hive.box<Project>("projects");
  latLng.LatLng userPos = latLng.LatLng(1, 1);
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled. Please enable the services');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState((){
        print(position);
          ctrl.move(latLng.LatLng(position.latitude, position.longitude), 14);
          userPos = latLng.LatLng(position.latitude, position.longitude);
    });
    }).catchError((FlutterError e) {
      debugPrint(e.message);
    });
  }

  @override
  void initState() {
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final circleMarkers = widget.project.circleMarkers;
    int currentMarkerId = widget.project.currentCircle?.key ?? 0;
    return GestureDetector(
        child: FlutterMap(
      mapController: ctrl,
      options: MapOptions(
          interactionOptions: InteractionOptions(
              flags: (widget.button == MapButtons.pan)
                  ? InteractiveFlag.all
                  : InteractiveFlag.none),
          onTap: (pos, latlng) {
            if (widget.button == MapButtons.delete) {
              final LayerHitResult? hitResult = hitNotifier.value;
              if (hitResult == null) return;
              showDialog(
                context: context,
                builder: (BuildContext context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Are you sure you want to delete this item?'),
                        const SizedBox(height: 15),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: FilledButton(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      Colors.red.shade400)),
                              onPressed: () {
                                setState(() {
                                  circleMarkers.remove(circleMarkers.firstWhere((elem)=>elem.id == hitNotifier.value?.hitValues.first));
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Delete'),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
          onPointerDown: (pos, latlng) {
            if (widget.button == MapButtons.circle) {
              setState(() {
                CircleMarkers item = CircleMarkers(
                    circleMarkers?.length != 0
                        ? circleMarkers!.last.displayOrder + 1
                        : 0,
                    new CircleMarker(
                        useRadiusInMeter: true,
                        borderStrokeWidth: 4,
                        borderColor: Colors.deepPurple,
                        color: Colors.deepPurpleAccent.withOpacity(0.5),
                        point: latlng,
                        radius: 1));
                widget.project.currentCircle = item;
              });
            }
          },
          onPointerUp: (pos, latlng) {
            if (widget.button == MapButtons.circle) {
              setState(() {
                CircleMarkers item = widget.project.currentCircle!;
                double rad = FlutterMapMath().distanceBetween(
                    item.marker.point.latitude,
                    item.marker.point.longitude,
                    latlng.latitude,
                    latlng.longitude,
                    "meters");
                CircleMarkers itemWithNewRad = new CircleMarkers.justDisplayOrder(item.displayOrder,);
                itemWithNewRad.marker = CircleMarker(
                    hitValue: itemWithNewRad.id,
                    useRadiusInMeter: true,
                    color: Colors.deepPurpleAccent.withOpacity(0.5),
                    borderColor: Colors.deepPurple,
                    borderStrokeWidth: 4,
                    point: item.marker.point,
                    radius: rad);
                circleMarkers.add(itemWithNewRad);
                widget.project.currentCircle = null;
              });
            }
          },
          initialCenter: latLng.LatLng(1, 1)),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.open_drone_path',
          // Plenty of other options available!
        ),
        CircleLayer(
            hitNotifier: hitNotifier,
            circles: circleMarkers!.map((elem) => elem.marker).toList()),
        MarkerLayer(
            markers: circleMarkers.map((elem) {
          return Marker(
              point: elem.marker.point,
              child: Center(child: Text(elem.displayOrder.toString())));
        }).toList()),
      ],
    ));
  }
}
