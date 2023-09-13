import 'package:cycling_route_planner/services/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/time_counter_provider.dart';
import 'info_field.dart';

class WeatherDetailsPopUpBox extends StatelessWidget {
  final double width;
  final double height;

  WeatherDetailsPopUpBox({
    required this.width,
    required this.height,
  });

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
                              fieldName: 'Temperature',
                              fieldValue: context.watch<WeatherProvider>().getTemperature(),
                            ),
                          ),
                          Expanded(
                            child: InfoField(
                              fieldName: 'Wind Speed',
                              fieldValue: context.watch<WeatherProvider>().getWindSpeed(),
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
                              fieldName: 'Rain Chance',
                              fieldValue: 'todo', // TODO
                            ),
                          ),
                          Expanded(
                            child: InfoField(
                              fieldName: 'UV Index',
                              fieldValue: 'todo', // TODO
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
