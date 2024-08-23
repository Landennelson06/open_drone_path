import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:open_drone_path/types/project.dart';

import 'ProjectPage.dart';

class ProjectListItem extends StatefulWidget {
  const ProjectListItem({super.key, required this.project, required this.callback});

  final Project project;
  final Function callback;

  @override
  State<ProjectListItem> createState() => _ProjectListItemState();
}

class _ProjectListItemState extends State<ProjectListItem> {
  final box = Hive.box<Project>("projects");
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background: Container(
          color: Colors.red,
        ),
        key: Key(widget.project.key.toString()),
        onDismissed: (DismissDirection direction)  async {
          await box.delete(widget.project.key);
          this.widget.callback(box.values.toList());

        },
        child: ListTile(
          onTap: () async {
            final something = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProjectPage(project: widget.project)),
            );
            setState((){});
          },
          tileColor: Colors.black12,
          title: Text(widget.project.name),
          subtitle: Text("Created at: " +
              DateFormat('yyyy-MM-dd H:m').format(widget.project.dateCreated)),
        ));
  }
}
