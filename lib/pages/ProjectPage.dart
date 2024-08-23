import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:intl/intl.dart';
import 'package:open_drone_path/Components/MapFull.dart';
import 'package:open_drone_path/Components/ProjectEditor.dart';
import 'package:open_drone_path/Components/ProjectGenerate.dart';
import 'package:open_drone_path/types/MapButtons.dart';
import 'package:open_drone_path/types/project.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key, required this.project});

  final Project project;

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  int tabNumber = 0;
  MapButtons button = MapButtons.pan;

  ColorSwatch<int> getColor(String btn) {
    if (MapButtons.values.byName(btn) == button) {
      return Colors.green;
    }
    return Colors.deepPurpleAccent;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            floatingActionButtonLocation: ExpandableFab.location,
            floatingActionButton: (tabNumber == 0)
                ? ExpandableFab(
                type: ExpandableFabType.up, children: [
                    FloatingActionButton.small(
                        heroTag: 2,
                        backgroundColor: getColor(MapButtons.pan.name),
                        child: const Icon(Icons.back_hand),
                        onPressed: () {
                          setState(() {
                            button = MapButtons.pan;
                          });
                        }),
                    FloatingActionButton.small(
                        heroTag: 3,
                        backgroundColor: getColor(MapButtons.circle.name),
                        child: const Icon(Icons.circle_outlined),
                        onPressed: () {
                          setState(() {
                            button = MapButtons.circle;
                          });
                        }),
                    FloatingActionButton.small(
                        heroTag: 4,
                        backgroundColor: getColor(MapButtons.polyline.name),
                        child: const Icon(Icons.polyline_outlined),
                        onPressed: () {
                          setState(() {
                            button = MapButtons.polyline;
                          });
                        }),
                    FloatingActionButton.small(
                        heroTag: 5,
                        backgroundColor: getColor(MapButtons.delete.name),
                        child: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            button = MapButtons.delete;
                          });
                        }),
                  ])
                : Container(),
            bottomNavigationBar: TabBar(
                onTap: (index) {
                  setState(() {
                    tabNumber = index;
                  });
                },
                tabs: const [
                  Tab(icon: Icon(Icons.map)),
                  Tab(icon: Icon(Icons.edit)),
                  Tab(icon: Icon(Icons.get_app_outlined))
                ]),
            appBar: AppBar(
              title: const Text("Edit Project"),
            ),
            body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MapFull(
                    project: widget.project,
                    button: button,
                  ),
                  ProjectEditor(project: widget.project),
                  ProjectGenerate(project: widget.project)
                ])));
  }
}
