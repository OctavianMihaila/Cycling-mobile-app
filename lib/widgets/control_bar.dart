import 'package:cycling_route_planner/services/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/location_provider.dart';
import '../services/time_counter_provider.dart';
import 'icon_button.dart';

class ControlBar extends StatefulWidget {
  final VoidCallback? onRecordPressed;
  final VoidCallback? onStopPressed;

  const ControlBar({super.key, this.onRecordPressed, this.onStopPressed});

  @override
  _ControlBarState createState() => _ControlBarState();
}

class _ControlBarState extends State<ControlBar> {
  bool isRecording = false; // Used to determine which control bar to show.
  bool isPaused = false; // If the recording is paused isRecording is still true.

  void _startRecording() {
    Provider.of<TimeCounterProvider>(context, listen: false).reset();
    Provider.of<LocationProvider>(context, listen: false).reset();
    Provider.of<WeatherProvider>(context, listen: false).reset();

    final double lat = Provider.of<LocationProvider>(context, listen: false).latitude;
    final double lon = Provider.of<LocationProvider>(context, listen: false).longitude;
    Provider.of<WeatherProvider>(context, listen: false).fetchWeather(lat, lon);

    setState(() {
      isRecording = true;
    });
    if (widget.onRecordPressed != null) {
      widget.onRecordPressed!(); // Calling the callback function.
    }
  }

  void _stopRecording() {
    setState(() {
      isRecording = false;
    });

    if (widget.onStopPressed != null) {
      widget.onStopPressed!();
    }
  }

  void _handlePause(BuildContext context) {
    if (isPaused) {
      Provider.of<TimeCounterProvider>(context, listen: false).resume();
      isPaused = false;
    } else {
      Provider.of<TimeCounterProvider>(context, listen: false).pause();
      isPaused = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isRecording) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.065,
        width: MediaQuery.of(context).size.width,
        color: Colors.orange[600],
        child: Row(
          children: [
            const SizedBox(width: 30),
            Expanded(
              child: CustomIconButton(
                icon: Icons.pause,
                text: 'Pause',
                onPressed: () {
                  _handlePause(context);
                },
              ),
            ),
            Expanded(
              child: CustomIconButton(
                icon: Icons.stop,
                text: 'Stop',
                onPressed: _stopRecording,
              ),
            ),
            const SizedBox(width: 30),
          ],
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * 0.065,
        width: MediaQuery.of(context).size.width,
        color: Colors.orange[600],
        child: Row(
          children: [
            const SizedBox(width: 30),
            Expanded(
              child: CustomIconButton(
                icon: Icons.explore,
                text: 'Explore routes',
                onPressed: () {
                  // TODO
                },
              ),
            ),
            Expanded(
              child: CustomIconButton(
                icon: Icons.radar,
                text: 'Record',
                onPressed: _startRecording,
              ),
            ),
            Expanded(
              child: CustomIconButton(
                icon: Icons.route,
                text: 'Create route',
                onPressed: () {
                  // TODO
                },
              ),
            ),
            const SizedBox(width: 30),
          ],
        ),
      );
    }
  }

}

