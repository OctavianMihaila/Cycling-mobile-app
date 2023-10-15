import 'package:flutter/material.dart';

class SpeedProvider extends ChangeNotifier {
  double _currentSpeed = 0;
  double _maxSpeed = 0;
  double _averageSpeed = 0;
  List<double> _recentSpeeds = [];
  final int maxRecentSpeeds = 5;

  String get currentSpeed => _currentSpeed.toStringAsFixed(2);
  String get maxSpeed => _maxSpeed.toStringAsFixed(2);
  // We get only one decimal because of the risk of rounding errors.
  String get averageSpeed => _averageSpeed.toStringAsFixed(1);

  String getCurrentSpeed(double distance, double seconds) {
    double distanceInKm = distance / 1000;
    double timeInHours = seconds / 3600;
    double currentSpeed = distanceInKm / timeInHours;

    if (currentSpeed > _maxSpeed) {
      _maxSpeed = currentSpeed;
    }

    // Add the current speed to the list of recent speeds
    _recentSpeeds.add(currentSpeed);

    // Keep only the last n speed measurements
    if (_recentSpeeds.length > maxRecentSpeeds) {
      _recentSpeeds.removeAt(0);
    }

    // Calculate the average speed from the recent measurements
    double sum = _recentSpeeds.reduce((a, b) => a + b);
    double averageSpeed = sum / _recentSpeeds.length;

    _currentSpeed = averageSpeed;
    return '${averageSpeed.toStringAsFixed(1)} km/h';
  }

  double getAverageSpeed(double distance, int seconds) {
    double hours = seconds / 3600;
    double distanceInKm = distance / 1000;

    if (seconds > 0) {
      _averageSpeed = distanceInKm / hours;
    } else {
      _averageSpeed = 0;
    }

    return _averageSpeed;
  }

  double getMaxSpeed() {
    return _maxSpeed;
  }
}
