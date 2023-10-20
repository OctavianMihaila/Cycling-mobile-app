import 'package:cycling_route_planner/services/elevation_provider.dart';
import 'package:cycling_route_planner/services/firestore_service.dart';
import 'package:cycling_route_planner/services/ride_details_calculator.dart';
import 'package:cycling_route_planner/services/speed_provider.dart';
import 'package:cycling_route_planner/widgets/google_maps.dart';
import 'package:cycling_route_planner/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../models/ride_info.dart';
import '../../services/location_provider.dart';
import '../../services/time_counter_provider.dart';
import '../../services/weather_provider.dart';
import '../../widgets/control_bar.dart';
import '../../widgets/ride_details_popup_box.dart';
import '../../widgets/weather_details_popup_box.dart';
import '../record_details/record_summary.dart';
import '../../widgets/save_ride_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  Set overlayEntries = {};
  // Used to store the overlay entries with their corresponding widget id.
  Map<String, OverlayEntry> popUpWidgets = {};
  bool isDetailsVisible = false;
  bool isWeatherVisible = false;

  void _showPopUpWidget(String widgetId, WidgetBuilder builder) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: builder);
    overlayState?.insert(overlayEntry);
    overlayEntries.add(overlayEntry);
    // Store the overlay entry with its corresponding widget id.
    popUpWidgets[widgetId] = overlayEntry;
  }

  void _hidePopUpWidget(String widgetId) {
    OverlayEntry? overlayEntry = popUpWidgets[widgetId];
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntries.remove(overlayEntry);
      popUpWidgets.remove(widgetId);
    }
  }

  void _showRecordDetails(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    _showPopUpWidget('record_details', (BuildContext context) {
      return Positioned(
        top: height * 0.7,
        left: width * 0.1,
        right: width * 0.1,
        child: RideDetailsPopUpBox(width: width, height: height),
      );
    });

    isDetailsVisible = true;
  }

  Future<void> _showWeatherDetails(BuildContext context) async {
    final double lat = Provider.of<LocationProvider>(context, listen: false).latitude;
    final double lon = Provider.of<LocationProvider>(context, listen: false).longitude;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    await Provider.of<WeatherProvider>(context, listen: false).fetchWeather(lat, lon);

    _showPopUpWidget('weather_details', (BuildContext context) {
      return Positioned(
        top: height * 0.45,
        left: width * 0.1,
        right: width * 0.1,
        child: WeatherDetailsPopUpBox(width: width, height: height),
      );
    });

    isWeatherVisible = true;
  }

  void _showCloseRecordDetailsButton(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    const double buttonSize = 50.0;

    _showPopUpWidget('close_record_button', (BuildContext context) {
      return Positioned(
        top: height * 0.2,
        right: width * 0.04,
        child: SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: ElevatedButton(
            onPressed: () {
              if (isDetailsVisible) {
                _hidePopUpWidget('record_details');
                isDetailsVisible = false;
              } else {
                _showRecordDetails(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[500],
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(5.0),
            ),
            child: const Icon(Icons.area_chart),
          ),
        ),
      );
    });
  }

  void _showCloseWeatherDetailsButton(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    const double buttonSize = 50.0;

    _showPopUpWidget('close_weather_button', (BuildContext context) {
      return Positioned(
        top: height * 0.285,
        right: width * 0.04,
        child: SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: ElevatedButton(
            onPressed: () {
              if (isWeatherVisible) {
                _hidePopUpWidget('weather_details');
                isWeatherVisible = false;
              } else {
                _showWeatherDetails(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[500],
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(5.0),
            ),
            child: const Icon(Icons.cloud),
          ),
        ),
      );
    });
  }

  RideInfo createRideInfo() {
    const double weight = 70.00;

    final String duration = Provider.of<TimeCounterProvider>(context, listen: false)
        .getCurrentTimeAsString();
    final int seconds = Provider.of<TimeCounterProvider>(context, listen: false)
        .seconds;
    final double distance = Provider.of<LocationProvider>(context, listen: false)
        .getCurrentDistanceAsDouble() / 1000;
    final double elevGained = Provider.of<LocationProvider>(context, listen: false).getElevationGain();
    final double elevLoss = Provider.of<LocationProvider>(context, listen: false).getElevationLoss();
    final double averageSpeed = Provider.of<SpeedProvider>(context, listen: false)
        .getAverageSpeed(distance, seconds);
    final double maxSpeed = Provider.of<SpeedProvider>(context, listen: false)
        .getMaxSpeed();
    final double calories = Provider.of<CaloriesBurnedProvider>(context, listen: false)
        .calculateCaloriesBurned(distance, weight, seconds);

    return RideInfo(
      duration: duration,
      distance: distance,
      averageSpeed: averageSpeed,
      maxSpeed: maxSpeed,
      calories: calories,
      elevationGained: elevGained,
      elevationLoss: elevLoss,
    );
  }

  void redirectToSummaryScreen(RideInfo rideInfo) {
    // Here we check if the context is mounted, because we are calling
    // setState() after a future has completed, and the context may no
    // longer be mounted at that point.
    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RideRecordScreen(rideInfo: rideInfo)),
    );
  }


  void _showSaveRideDialog(RideInfo rideInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SaveRideDialog(
          onSaveCallback: () async {
            Map<String, dynamic> data = {
              'userId': user!.uid,
              'duration': rideInfo.duration,
              'distance': rideInfo.distance.toStringAsFixed(2),
              'avgSpeed': rideInfo.averageSpeed.toStringAsFixed(2),
              'avgPace': rideInfo.calculateAvgPace(),
              'maxSpeed': rideInfo.maxSpeed.toStringAsFixed(2),
              'calories': rideInfo.calories.toStringAsFixed(2),
              'elevationGained': rideInfo.elevationGained.toStringAsFixed(2),
              'elevationLoss': rideInfo.elevationLoss.toStringAsFixed(2),
            };
            FirestoreService firestoreService = FirestoreService();
            firestoreService.addActivity(data);

            redirectToSummaryScreen(rideInfo);
          },
        );
      },
    );
  }


  @override
  void dispose() {
    for (var overlayEntry in overlayEntries) {
      overlayEntry.remove();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: const Text('Cycling peloton'),
        backgroundColor: Colors.orange[600],
      ),
      body: Material(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: MapFromGoogle(),
              ),
            ),
            ControlBar(
              onRecordPressed: () {
                _showCloseRecordDetailsButton(context);
                _showCloseWeatherDetailsButton(context);
                _showRecordDetails(context);
              },
              onStopPressed: () {
                RideInfo rideInfo = createRideInfo();
                _showSaveRideDialog(rideInfo);
                _hidePopUpWidget('record_details');
                _hidePopUpWidget('weather_details');
                _hidePopUpWidget('close_record_button');
                _hidePopUpWidget('close_weather_button');
              },
            ),
          ],
        ),
      ),
    );
  }
}
