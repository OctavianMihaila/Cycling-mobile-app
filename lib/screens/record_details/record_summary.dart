import 'package:flutter/material.dart';

import '../../models/ride_info.dart';
import '../../widgets/ride_record_detail.dart';

class RideRecordScreen extends StatelessWidget {
  final RideInfo rideInfo;

  RideRecordScreen({required this.rideInfo});

  String formatDoubleWithTwoDecimals(double value) {
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Record Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RideRecordDetail("Avg Pace", "${rideInfo.calculateAvgPace()} min/km"),
            RideRecordDetail("Avg Speed", "${formatDoubleWithTwoDecimals(rideInfo.averageSpeed)} km/h"),
            RideRecordDetail("Calories", "${formatDoubleWithTwoDecimals(rideInfo.calories)} kcal"),
            RideRecordDetail("Distance", "${formatDoubleWithTwoDecimals(rideInfo.distance)} km"),
            RideRecordDetail("Duration", rideInfo.duration),
            RideRecordDetail("Elev. gained", "${formatDoubleWithTwoDecimals(rideInfo.elevationGained)} m"),
            RideRecordDetail("Elev. loss", "${formatDoubleWithTwoDecimals(rideInfo.elevationLoss)} m"),
            RideRecordDetail("Max Speed", "${formatDoubleWithTwoDecimals(rideInfo.maxSpeed)} km/h"),
          ],
        ),
      ),
    );
  }
}
