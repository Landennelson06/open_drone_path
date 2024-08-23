import 'dart:io';
import 'dart:math';

import 'package:archive/archive.dart';
import 'package:converter/converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:geoxml/geoxml.dart';
import 'package:open_drone_path/helpers/TemplateHelper.dart';
import 'package:open_drone_path/helpers/WPMLhelper.dart';
import 'package:open_drone_path/types/CircleMarkers.dart';
import 'package:open_drone_path/types/project.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

class ProjectGenerate extends StatefulWidget {
  const ProjectGenerate({super.key, required this.project});

  final Project project;

  @override
  State<ProjectGenerate> createState() => _ProjectGenerateState();
}

class _ProjectGenerateState extends State<ProjectGenerate> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.project.circleMarkers.toList().length,
        itemBuilder: (ctx, cnt) {
          List<CircleMarkers> markers = widget.project.circleMarkers.toList();
          return ListTile(
            title: Text("Circle " + markers[cnt].displayOrder.toString()),
            trailing: IconButton(
                onPressed: () async {
                  var appDir = await getApplicationDocumentsDirectory();
                  String dir = appDir.absolute.path +
                      "\\open_drone_path\\projects\\" +
                      widget.project.name;
                  Directory dataDir =
                      await Directory(dir + "\\data").create(recursive: true);
                  Directory exportDir =
                      await Directory(dir + "\\export").create(recursive: true);
                  CircleMarkers mk = markers[cnt];
                  Length offsetLen = Length(
                      tan(widget.project.generateOptions.cameraAngle *
                              (pi / 180)) *
                          widget.project.generateOptions.altitude,
                      "ft");
                  double radius = mk.marker.radius + offsetLen.valueIn("m");
                  XmlBuilder builder = new XmlBuilder();
                  builder.processing('xml', 'version="1.0"');
                  builder.element("kml", attributes: {
                    'xmlns': 'http://www.opengis.net/kml/2.2',
                    "xmlns:wpml": "http://www.dji.com/wpmz/1.0.2"
                  }, nest: () {
                    builder.element("Document", nest: () {
                      WPMLhelper.generateMissionConfig(widget.project, builder);
                      builder.element("Folder", nest: () {
                        WPMLhelper.makeWaypointHeader(widget.project, builder);
                        var items = 15;
                        for (var i = 0; i < items; i++) {
                          WPMLhelper.makeWaypoint(
                              i,
                              builder,
                              widget.project,
                              FlutterMapMath().destinationPoint(
                                  mk.marker.point.latitude,
                                  mk.marker.point.longitude,
                                  radius,
                                  360 / items * (i + 1)));
                        }
                      });
                    });
                  });
                  final waylinesDocument = builder.buildDocument();
                  File file = await File(dataDir.absolute.path + "\\waylines.wpml")
                      .writeAsString(waylinesDocument.toXmlString(pretty: true));
                  XmlBuilder waylinesBuilder = new XmlBuilder();
                  TemplateHelper.generateTemplate(widget.project, waylinesBuilder);
                  final templateDocument = waylinesBuilder.buildDocument();
                  File templateFile = await File(dataDir.absolute.path + "\\template.kml")
                      .writeAsString(templateDocument.toXmlString(pretty: true));
                  Archive archive = new Archive();
                  final fileBytes = await file.readAsBytes();
                  archive.addFile(ArchiveFile("template.kml", fileBytes.length, fileBytes));
                  final templateBytes  = await templateFile.readAsBytes();
                  archive.addFile(ArchiveFile("waylines.wpml", templateBytes.length, templateBytes));
                  final zipEncoder = ZipEncoder();
                  final encoded = zipEncoder.encode(archive);
                  if(encoded == null) return;
                  final zipFile = await File(exportDir.absolute.path + "\\" + widget.project.name + ".kmz").writeAsBytes(encoded);
                },
                icon: Icon(Icons.chevron_right)),
          );
        });
  }
}
