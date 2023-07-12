import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  double _latitude = 0;
  double _longitude = 0;

  double get latitude => _latitude;
  double get longitude => _longitude;

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
      // if position is null, it will assign the result
      // of asynchronous function to the variable.
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
}
