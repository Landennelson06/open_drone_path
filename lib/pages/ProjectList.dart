import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:math';
import '../types/project.dart';
import 'ProjectListItem.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key, required this.title});

  final String title;

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  final box = Hive.box<Project>("projects");
  void _incrementCounter() {
    box.add(
        new Project(DateFormat('dd/MM/YYYY H:m').format(DateTime.now())));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Project> _proj = box.values.toList();
    void callback(List<Project> proj) {
      setState(() {
        _proj = proj;
      });
    }
    print(box.values.toList().length);
    return Scaffold(
      appBar: AppBar(
        title: Text("Open Drone Path"),
      ),
      body:
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: box.values.toList().length,
                itemBuilder:
                    (BuildContext context, int count) {
                  return ProjectListItem(project: box.values.toList()[count]!, callback: callback,);
                }
            )
            ),
          ]
      ),
      floatingActionButton: FloatingActionButton(
        heroTag:1,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
