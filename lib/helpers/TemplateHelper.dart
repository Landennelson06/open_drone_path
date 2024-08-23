import 'package:open_drone_path/helpers/WPMLhelper.dart';
import 'package:open_drone_path/types/project.dart';
import 'package:xml/xml.dart';

class TemplateHelper{
  static void generateTemplate(Project project, XmlBuilder builder){
    builder.processing('xml', 'version="1.0"');
    builder.element("kml", attributes: {
    'xmlns': 'http://www.opengis.net/kml/2.2',
    "xmlns:wpml": "http://www.dji.com/wpmz/1.0.2"
    }, nest: () {
      builder.element("Document", nest: () {
        builder.element("wpml:author", nest: () => builder.text("Testing"));
        builder.element("wpml:createTime",
            nest: () =>
                builder.text(DateTime.now().millisecondsSinceEpoch.toString()));
        builder.element("wpml:updateTime",
            nest: () =>
                builder.text(DateTime.now().millisecondsSinceEpoch.toString()));
        WPMLhelper.generateMissionConfig(project,builder);
      });
    });
  }
}