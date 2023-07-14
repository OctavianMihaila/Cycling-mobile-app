import 'dart:async';

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
  GoogleMapController? _controller;
  List<LatLng> _routePoints = [];
  final Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;
  CameraMode _cameraMode = CameraMode.Follow;
  StreamSubscription<Position>? _positionStreamSubscription;

  double get latitude => _latitude;
  double get longitude => _longitude;
  GoogleMapController? get controller => _controller;
  List<LatLng> get routePoints => _routePoints;
  CameraMode get cameraMode => _cameraMode;

  set controller(GoogleMapController? controller) {
    _controller = controller;
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
        final double newLatitude = position.latitude;
        final double newLongitude = position.longitude;

        final double distance = Geolocator.distanceBetween(
          _latitude,
          _longitude,
          newLatitude,
          newLongitude,
        );

        // Added this to prevent refreshing the UI when the user is not moving
        if (distance >= 50) {
          _latitude = newLatitude;
          _longitude = newLongitude;

          // Create a LatLng object with the new location
          final LatLng newLocation = LatLng(_latitude, _longitude);

          // Add the new location to the route points
          addRoutePoint(newLocation);

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

  void setCameraMode(CameraMode mode) {
    _cameraMode = mode;
    notifyListeners();
  }
}
