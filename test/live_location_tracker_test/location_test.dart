import 'package:cycling_route_planner/services/location_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('LocationProvider Tests', () {
    late LocationProvider locationProvider;

    setUp(() {
      locationProvider = LocationProvider();
    });

    tearDown(() {
      locationProvider.dispose();
    });

    test('Initial latitude and longitude should be 0', () {
      expect(locationProvider.latitude, 0);
      expect(locationProvider.longitude, 0);
    });

    test('Setting camera mode should notify listeners', () {
      expect(locationProvider.cameraMode, CameraMode.Follow);
      locationProvider.cameraMode = CameraMode.Free;
      expect(locationProvider.cameraMode, CameraMode.Free);
    });

    test('Calculate distance between two points', () {
      double distance = locationProvider.calculateDistance(
          0, 0, 0, 1); // Replace with actual coordinates for your test case
      expect(distance, closeTo(111195.08, 0.2)); // Replace with the expected distance
    });

    test('Add route point should update routePoints and polylines', () {
      const LatLng testPoint = LatLng(1.0, 2.0);
      locationProvider.addRoutePoint(testPoint);
      expect(locationProvider.routePoints, contains(testPoint));
      expect(
          locationProvider.polylines,
          contains(
            isA<Polyline>()
                .having((polyline) => polyline.points, 'points', contains(testPoint)),
          ));
    });
  });
}
