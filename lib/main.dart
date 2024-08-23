import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hive/hive.dart';
import 'package:open_drone_path/pages/ProjectList.dart';
import 'package:open_drone_path/types/CircleMarkers.dart';
import 'package:open_drone_path/types/generateOptions.dart';
import 'package:open_drone_path/types/project.dart';
import 'package:hive_flutter/hive_flutter.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter("open_drone_path/db");
  Hive.registerAdapter<Project>(ProjectAdapter());
  Hive.registerAdapter<GenerateOptions>(GenerateOptionsAdapter());
  Hive.registerAdapter<CircleMarkers>(CircleMarkersAdapter());
  Hive.registerAdapter<FlightDirection>(FlightDirectionAdapter());
  Hive.registerAdapter<WaypointOptions>(WaypointOptionsAdapter());
  await Hive.openBox<Project>("projects");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenDronePath',
      theme: ThemeData.dark(useMaterial3: true),
      home: const ProjectList(title: 'Open Drone Path'),
    );
  }
}
