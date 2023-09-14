import 'package:cycling_route_planner/services/weather_provider.dart';
import 'package:cycling_route_planner/widgets/icon_text_info_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherDetailsPopUpBox extends StatelessWidget {
  final double width;
  final double height;

  WeatherDetailsPopUpBox({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, _) {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconTextInfoField(
                        fieldValue: context.watch<WeatherProvider>().getTemperature(),
                        iconData: WeatherIcons.thermometer
                    ),
                    IconTextInfoField(
                        fieldValue: context.watch<WeatherProvider>().getWindSpeed(),
                        iconData: context.watch<WeatherProvider>().getWindDirectionIcon()
                    ),
                    IconTextInfoField(
                        fieldValue: context.watch<WeatherProvider>().getPop(),
                        iconData: WeatherIcons.umbrella
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