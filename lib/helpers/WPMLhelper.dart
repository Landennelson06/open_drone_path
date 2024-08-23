import 'package:converter/converter.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_drone_path/types/project.dart';
import 'package:xml/xml.dart';

class WPMLhelper {
  static void generateMissionConfig(Project project, XmlBuilder builder) {
    builder.element("wpml:missionConfig", nest: () {
      builder.element("wpml:flyToWaylineMode",
          nest: () => builder.text("safely"));
      builder.element("wpml:finishAction",
          nest: () => builder.text("goHome")); // TODO
      builder.element("wpml:exitOnRCLost",
          nest: () => builder.text("executeLostAction")); // TODO
      builder.element("wpml:executeRCLostAction",
          nest: () => builder.text("hover")); // TODO
      builder.element("wpml:takeOffSecurityHeight",
          nest: () => builder.text("60")); // TODO
      builder.element("wpml:globalTransitionalSpeed",
          nest: () => builder.text("2.5")); // TODO
      builder.element("wpml:droneInfo", nest: () {
        builder.element("wpml:droneEnumValue",
            nest: () => builder.text("68")); // TODO
        builder.element("wpml:droneSubEnumValue",
            nest: () => builder.text("0")); // TODO
      });
    });
  }

  static void makeWaypointHeader(Project project, XmlBuilder builder) {
    builder.element("wpml:templateId", nest: () => builder.text("0"));
    builder.element("wpml:executeHeightMode",
        nest: () => builder.text("WGS84"));
    builder.element("wpml:waylineId", nest: () => builder.text("0"));
    builder.element("wpml:autoFlightSpeed", nest: () => builder.text("2"));
  }

  static void makeWaypoint(
      int index, XmlBuilder builder, Project project, LatLng coords) {
    builder.element("Placemark", nest: () {
      builder.element("Point", nest: () {
        builder.element("coordinates",
            nest: () => builder.text(coords.longitude.toString() +
                "," +
                coords.latitude.toString()));
      });
      builder.element("wpml:index", nest: () => builder.text(index));
      builder.element("wpml:ellipsoidHeight",
          nest: () => builder.text(
              Length(project.generateOptions.altitude, "ft").valueIn("m")));
      builder.element("wpml:executeHeight",
          nest: () => builder.text(
              Length(project.generateOptions.altitude, "ft").valueIn("m")));
      builder.element("wpml:waypointSpeed", nest: () => builder.text("2"));
      builder.element("wpml:waypointHeadingParam", nest: () {
        builder.element("wpml:waypointHeadingMode",
            nest: () => builder.text("followWayline"));
      });
      builder.element("wpml:waypointTurnParam", nest: () {
        builder.element("wpml:waypointTurnMode",
            nest: () =>
                builder.text("toPointAndStopWithDiscontinuityCurvature"));
        builder.element("wpml:waypointTurnDampingDist",
            nest: () => builder.text("0"));
      });
    });
  }
}
