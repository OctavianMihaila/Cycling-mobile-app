import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum CameraMode {
  Follow,
  Free,
}

class LocationProvider with ChangeNotifier {
  double _latitude = 0;
  double _longitude = 0;
  double _startLatitude = 0;
  double _startLongitude = 0;

  GoogleMapController? _controller;
  List<LatLng> _routePoints = [];
  final Set<Polyline> _polylines = {};
  CameraMode _cameraMode = CameraMode.Follow;
  StreamSubscription<Position>? _positionStreamSubscription;

  DateTime? _lastSegmentStartTime = DateTime.now();

  double get latitude => _latitude;
  double get longitude => _longitude;
  Set<Polyline> get polylines => _polylines;
  GoogleMapController? get controller => _controller;
  List<LatLng> get routePoints => _routePoints;
  CameraMode get cameraMode => _cameraMode;

  set controller(GoogleMapController? controller) {
    _controller = controller;
  }

  set cameraMode(CameraMode cameraMode) {
    _cameraMode = cameraMode;
    notifyListeners();
  }

  String getCurrentDistanceAsString() {
    double distanceInKm = getCurrentDistanceAsDouble();

    return '${(distanceInKm / 1000).toStringAsFixed(2)} km';
  }

  double getCurrentDistanceAsDouble() {
    double distanceInM = 0;
    for (int i = 0; i < _routePoints.length - 1; i++) {
      distanceInM += Geolocator.distanceBetween(
        _routePoints[i].latitude,
        _routePoints[i].longitude,
        _routePoints[i + 1].latitude,
        _routePoints[i + 1].longitude,
      );
    }
    
    return distanceInM;
  }

  double getDistanceInLastSegment() {
    if (_routePoints.length < 2) {
      return 0;
    }

    final int secondLastIndex = _routePoints.length - 2;
    final double distanceInMeters = calculateDistance(
      _routePoints[secondLastIndex].latitude,
      _routePoints[secondLastIndex].longitude,
      _routePoints[secondLastIndex + 1].latitude,
      _routePoints[secondLastIndex + 1].longitude,
    );

    return distanceInMeters;
  }

  double getElapsedLastSegmentTime() {
    if (_lastSegmentStartTime == null) {
      return 0.0;
    }
    print('^^^^^^^^^^^^^^^^^^^Last segment start time: $_lastSegmentStartTime');

    final Duration elapsedDuration = DateTime.now().difference(_lastSegmentStartTime!);

    return elapsedDuration.inMilliseconds / 1000.0;
  }

  void setCameraMode(CameraMode mode) {
    _cameraMode = mode;
    notifyListeners();
  }

  void reset() {
    _routePoints = [];
    _polylines.clear();
    notifyListeners();
  }

  // Calculate the distance between two points using the Haversine formula
  double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    const int earthRadius = 6371000; // in meters
    double latDistance = degreesToRadians(endLat - startLat);
    double lngDistance = degreesToRadians(endLng - startLng);
    double a = math.sin(latDistance / 2) * math.sin(latDistance / 2) +
        math.cos(degreesToRadians(startLat)) * math.cos(degreesToRadians(endLat)) *
            math.sin(lngDistance / 2) * math.sin(lngDistance / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  Future<bool> checkLocationPermission() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('Location access denied');
        return false;
      } else {
        print('Location access granted');
        return true;
      }
    } else {
      print('Location access already granted');
      return true;
    }
  }

  Future<void> fetchLocation() async {
    try {
      Position? position = await Geolocator.getLastKnownPosition();
      position ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _latitude = position.latitude;
      _longitude = position.longitude;
    } catch (e) {
      print('Could not fetch location: $e');
    }
    notifyListeners();
  }

  void startListeningForLocationChanges() {
    _positionStreamSubscription = Geolocator.getPositionStream().listen(
          (Position position) {
        // saving the initial position
        if (_startLatitude == 0 && _startLongitude == 0) {
          _startLatitude = position.latitude;
          _startLongitude = position.longitude;
        }

        final double newLatitude = position.latitude;
        final double newLongitude = position.longitude;

        final double distance = Geolocator.distanceBetween(
          _latitude,
          _longitude,
          newLatitude,
          newLongitude,
        );

        // Added this to prevent refreshing the UI when the user is not moving
        if (distance >= 0.5) {
          _latitude = newLatitude;
          _longitude = newLongitude;

          // Create a LatLng object with the new location
          final LatLng newLocation = LatLng(_latitude, _longitude);

          // Add the new location to the route points
          addRoutePoint(newLocation);

          // Setting the start time of the segment
          if (_lastSegmentStartTime != null) {
            _lastSegmentStartTime = DateTime.now();
          }

          notifyListeners();

          if (_cameraMode == CameraMode.Follow) {
            // Get the visible region of the map
            final LatLngBounds visibleRegion = _controller!.getVisibleRegion() as LatLngBounds;

            // Check if the new location is outside the visible region
            if (!visibleRegion.contains(newLocation)) {
              _controller?.animateCamera(
                CameraUpdate.newLatLng(newLocation),
              );
            }
          } else {
            _lastSegmentStartTime = null;
          }
        }
      },
    );
  }

  void stopListeningForLocationChanges() {
    _positionStreamSubscription?.cancel();
  }

  void addRoutePoint(LatLng point) {
    _routePoints.add(point);

    // Create a Polyline object with the route points
    final Polyline polyline = Polyline(
      polylineId: const PolylineId('route'),
      width: 5,
      color: Colors.blue,
      points: _routePoints,
    );

    // Add the Polyline to the polylines set
    _polylines.add(polyline);

    notifyListeners();
  }
}