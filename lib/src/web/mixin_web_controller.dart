import 'dart:html' as html;

import 'package:js/js_util.dart';

import '../../flutter_osm_plugin.dart';
import 'interop/models/geo_point_js.dart';
import 'interop/osm_interop.dart' as interop show addPosition, locateMe;

mixin ControllerWebMixin {
  Future<GeoPoint> currentLocation() async {
    Map<String, double> result = await Future.microtask(() async {
      Map<String, dynamic>? value =
          await html.promiseToFutureAsMap(interop.locateMe());
      if (value!.containsKey("error")) {
        throw Exception(value["message"]);
      }
      return Map<String, double>.from(value);
    });
    return GeoPoint.fromMap(result);
  }

  Future<void> addPosition(GeoPoint point) async {
    await promiseToFuture(interop.addPosition(GeoPointJs(
      lat: point.latitude,
      lon: point.longitude,
    )));
  }
}
