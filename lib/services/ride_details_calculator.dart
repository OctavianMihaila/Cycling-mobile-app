import 'package:cycling_route_planner/services/speed_provider.dart';
import 'package:cycling_route_planner/services/time_counter_provider.dart';
import 'package:flutter/material.dart';

import 'location_provider.dart';

class CaloriesBurnedProvider with ChangeNotifier {
  // Constants for MET values and corresponding speed thresholds.
  static const double metLeisure = 5.8;
  static const double metLightEffort = 6.8;
  static const double metModerateEffort = 8.0;
  static const double metVigorousEffort = 10.0;
  final double distance = LocationProvider().getCurrentDistanceAsDouble();
  final int duration = TimeCounterProvider().seconds;

  // Function to determine MET value based on distance and duration.
  double calculateMetValue() {
    final double avgSpeed = SpeedProvider().getAverageSpeed(distance, duration);

    if (avgSpeed < 10) {
      return metLeisure;
    } else if (avgSpeed >= 10 && avgSpeed < 12) {
      return metLightEffort;
    } else if (avgSpeed >= 12 && avgSpeed < 14) {
      return metModerateEffort;
    } else {
      return metVigorousEffort;
    }
  }

  // Calculate calories burned based on MET, weight, and duration.
  double calculateCaloriesBurned(double distance, double weight, int duration) {
    final double metValue = calculateMetValue();
    // Divide by 60 to convert minutes to hours
    return (metValue * weight * duration) / 60.0;
  }
}
