import 'package:cycling_route_planner/services/location_provider.dart';
import 'package:cycling_route_planner/services/speed_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/time_counter_provider.dart';
import 'info_field.dart';

class RideDetailsPopUpBox extends StatelessWidget {
  final double width;
  final double height;
  String _latestSpeedDisplayed = '0.0 km/h';
  static const double timeThreshold = 0.3;

  RideDetailsPopUpBox({
    required this.width,
    required this.height,
  });

  String _getCurrentSpeed(BuildContext context) {
    final double distance = context.watch<LocationProvider>().getDistanceInLastSegment();
    final double seconds = context.watch<LocationProvider>().getElapsedLastSegmentTime();

    // Not allowing the speed to be updated if the time is less
    // than 0.1 seconds because those are not trustable segments.
    if (seconds < timeThreshold || distance == 0) {
      return _latestSpeedDisplayed;
    }
    else {
      _latestSpeedDisplayed = context.watch<SpeedProvider>().getCurrentSpeed(distance, seconds);
      return _latestSpeedDisplayed;
    }
  }

  String _getAverageSpeed(BuildContext context) {
    final double distance = context.watch<LocationProvider>().getCurrentDistanceAsDouble();
    final int seconds = context.watch<TimeCounterProvider>().seconds;

    context.watch<SpeedProvider>().getAverageSpeed(distance, seconds);

    return '${context.watch<SpeedProvider>().averageSpeed} km/h';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeCounterProvider>(
      builder: (context, timeCounterProvider, _) {
        return Stack(
          children: [
            Center(
              child: Container(
                width: width * 0.8,
                height: height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: InfoField(
                              fieldName: 'Duration',
                              fieldValue: context.watch<TimeCounterProvider>().getCurrentTimeAsString(),
                            ),
                          ),
                          Expanded(
                            child: InfoField(
                              fieldName: 'Speed',
                              fieldValue: _getCurrentSpeed(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: InfoField(
                              fieldName: 'Distance',
                              fieldValue: context.watch<LocationProvider>().getCurrentDistanceAsString(),
                            ),
                          ),
                          Expanded(
                            child: InfoField(
                              fieldName: 'Avg Speed',
                              fieldValue: _getAverageSpeed(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
