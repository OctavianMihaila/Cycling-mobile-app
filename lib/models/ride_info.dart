import 'package:cycling_route_planner/services/time_counter_provider.dart';
import 'package:flutter/material.dart';

class RideInfo {
  final String title = 'default title';
  final String duration; // HH:mm:ss
  final double distance; // km
  final double averageSpeed; // km/h
  final double maxSpeed; // km/h
  final double calories; // kcal
  final double elevationGained; // m
  final double elevationLoss; // m

  const RideInfo({required this.duration,
    required this.distance, required this.averageSpeed,
    required this.maxSpeed, required this.calories,
    required this.elevationGained, required this.elevationLoss});

  set title(String title) {
    title = title;
  }

  String calculateAvgPace() {
    int seconds = TimeCounterProvider().seconds;
    int minutes = (seconds / 60).floor();
    seconds = seconds % 60;
    return '$minutes:$seconds';
  }
}
