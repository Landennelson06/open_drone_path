import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:open_drone_path/Components/MapFull.dart';
import 'package:open_drone_path/types/project.dart';

import '../types/generateOptions.dart';

class ProjectEditor extends StatefulWidget {
  const ProjectEditor({super.key, required this.project});

  final Project project;

  @override
  State<ProjectEditor> createState() => _ProjectEditorState();
}

class _ProjectEditorState extends State<ProjectEditor> {
  final box = Hive.box<Project>("projects");

  void updateDB() {
    widget.project.save();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      ListTile(
        title: Text("Project name"),
        subtitle: TextField(
          onSubmitted: (val) {
            widget.project.name = val;
            updateDB();
            setState(() {});
          },
          controller: TextEditingController()..text = widget.project.name,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a name',
          ),
        ),
      ),
      ListTile(
          title: Text("Fly in:"),
          subtitle: Text("This is the direction your drone will fly in"),
          trailing: DropdownMenu(
            onSelected: (val) {
              widget.project.generateOptions.flightDirection =
                  FlightDirection.values.byName(val!);
              updateDB();
            },
            initialSelection:
                widget.project.generateOptions.flightDirection.name,
            dropdownMenuEntries: [
              DropdownMenuEntry(value: "northSouth", label: "North-South"),
              DropdownMenuEntry(value: "eastWest", label: "East-West"),
              DropdownMenuEntry(value: "both", label: "Both")
            ],
          )),
      ListTile(
          title: Text("Waypoint Action"),
          subtitle: Text("What should the drone do at each waypoint?"),
          trailing: DropdownMenu(
            onSelected: (val) {
              widget.project.generateOptions.waypointOptions =
                  WaypointOptions.values.byName(val!);
              updateDB();
            },
            initialSelection:
                widget.project.generateOptions.waypointOptions.name,
            dropdownMenuEntries: [
              DropdownMenuEntry(value: "noAction", label: "No Action"),
              DropdownMenuEntry(value: "takePicture", label: "Take a Picture"),
            ],
          )),
      ListTile(
        title: Text("Path Distance"),
        subtitle: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          onSubmitted: (val) {
            widget.project.generateOptions.spaceBetweenLines = int.parse(val);
            updateDB();
            setState(() {});
          },
          controller: TextEditingController()..text = widget.project.generateOptions.spaceBetweenLines.toString(),
          decoration: InputDecoration(
            suffixText: "ft",
            helper: Text(
                "This is the distance between lines that are generated for the path"),
            border: OutlineInputBorder(),
            hintText: 'Enter a name',
          ),
        ),
      ),
          ListTile(
            title: Text("Waypoint Distance"),
            subtitle: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onSubmitted: (val) {
                widget.project.generateOptions.generateDistance = int.parse(val);
                updateDB();
                setState(() {});
              },
              controller: TextEditingController()..text = widget.project.generateOptions.generateDistance.toString(),
              decoration: const InputDecoration(
                suffixText: "ft",
                helper: Text(
                    "This is the how often the line places a waypoint. Can be used to take more pictures. Set to zero to only put the required waypoints"),
                border: OutlineInputBorder(),
              ),
            ),
          ),
      Divider(),
      ListTile(
        title: Text("Altitude"),
        subtitle: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          onSubmitted: (val) {
            widget.project.generateOptions.altitude = int.parse(val);
            updateDB();
            setState(() {});
          },
          controller: TextEditingController()
            ..text = widget.project.generateOptions.altitude.toString(),
          decoration: InputDecoration(
            suffixText: "ft",
            border: OutlineInputBorder(),
            hintText: 'Enter a name',
          ),
        ),
      ),
      ListTile(
        title: Text("Camera Angle"),
        subtitle: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          onSubmitted: (val) {
            widget.project.generateOptions.cameraAngle = int.parse(val);
            updateDB();
            setState(() {});
          },
          controller: TextEditingController()
            ..text = widget.project.generateOptions.cameraAngle.toString(),
          decoration: InputDecoration(
            suffixText: "degrees",
            prefixText: "-",
            helper: Text(
                "This is the angle of the camera. It is automatically converted into a negative"),
            border: OutlineInputBorder(),
            hintText: 'Enter a name',
          ),
        ),
      ),
      ListTile(
        title: Text("Flight Area is subject area"),
        subtitle: Text(
            "This will make the drawn area the target area, offsetting the flight by the data from the settings above"),
        trailing: Checkbox(
            value: widget.project.generateOptions.flightAreaOffset,
            onChanged: (val) {
              setState(() {
                ;
                widget.project.generateOptions.flightAreaOffset = val!;
              });
            }),
      ),
      ListTile(
        title: Text("Offset Value"),
        subtitle: Text(
            "Your offset value is: ${tan(widget.project.generateOptions.cameraAngle * (pi / 180)) * widget.project.generateOptions.altitude} ft"),
      ),
    ]));
  }
}
