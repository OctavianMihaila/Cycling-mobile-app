import 'package:flutter/material.dart';

class RideInfo extends StatelessWidget {
  final String title;
  final Duration duration; // HH:mm:ss
  final double distance; // km
  final double averageSpeed; // km/h
  final double maxSpeed; // km/h
  // TODO: Add more fields (elevation, calories, etc.)

  const RideInfo({required this.title, required this.duration, required this.distance, required this.averageSpeed, required this.maxSpeed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: // TODO
    );
  }