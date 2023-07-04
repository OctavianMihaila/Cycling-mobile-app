import 'package:geolocator/geolocator.dart';

class Location {
  double _latitude = 0;
  double _longitude = 0;

  double getLatitude() {
    return _latitude;
  }

  double getLongitude() {
    return _longitude;
  }

  static final Location _instance = Location._internal();

  factory Location() {
    return _instance;
  }

  Location._internal();

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
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _latitude = position.latitude;
      _longitude = position.longitude;
    } catch (e) {
      print('Could not fetch location: $e');
    }
  }
}
