import 'package:cycling_route_planner/screens/auth/auth.dart';
import 'package:cycling_route_planner/widgets/google_maps.dart';
import 'package:cycling_route_planner/widgets/popup_menu.dart';
import 'package:cycling_route_planner/widgets/splash_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widgets/control_bar.dart';
import '../../widgets/icon_button.dart';
import '../../widgets/popup_box.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  List<OverlayEntry> overlayEntries = [];
  // Used to store the overlay entries with their corresponding widget id
  Map<String, OverlayEntry> popUpWidgets = {};
  bool isDetailsVisible = false;
  bool isWeatherVisible = false;

  void _showPopUpWidget(String widgetId, WidgetBuilder builder) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: builder);
    overlayState?.insert(overlayEntry);
    overlayEntries.add(overlayEntry);
    popUpWidgets[widgetId] = overlayEntry; // Store the overlay entry with its corresponding widget id
  }

  void _hidePopUpWidget(String widgetId) {
    OverlayEntry? overlayEntry = popUpWidgets[widgetId];
    if (overlayEntry != null) {
      overlayEntry.remove(); // Remove the overlay entry
      overlayEntries.remove(overlayEntry);
      popUpWidgets.remove(widgetId); // Remove it from the map
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
        child: RecordDetailsPopUpBox(width: width, height: height),
      );
    });

    isDetailsVisible = true;
  }

  void _showWeatherDetails(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    _showPopUpWidget('weather_details', (BuildContext context) {
      return Positioned(
        top: height * 0.45,
        left: width * 0.1,
        right: width * 0.1,
        child: RecordDetailsPopUpBox(width: width, height: height),
      );
    });

    isWeatherVisible = true;
  }

  void _showCloseRecordDetailsButton(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double buttonSize = 50.0;

    _showPopUpWidget('close_record_button', (BuildContext context) {
      return Positioned(
        top: height * 0.15,
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
            child: Icon(Icons.area_chart),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: CircleBorder(),
              padding: EdgeInsets.all(5.0),
            ),
          ),
        ),
      );
    });
  }

  void _showCloseWeatherDetailsButton(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double buttonSize = 50.0;

    _showPopUpWidget('close_weather_button', (BuildContext context) {
      return Positioned(
        top: height * 0.235,
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
            child: Icon(Icons.cloud),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: CircleBorder(),
              padding: EdgeInsets.all(5.0),
            ),
          ),
        ),
      );
    });
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
        title: Text('Cycling peloton'),
        backgroundColor: Colors.orange[600],
      ),
      body: Material(
        child: Column(
          children: [
            Expanded(
              child: Container(
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
                _showWeatherDetails(context);
              },
              onStopPressed: () {
                _hidePopUpWidget('record_details');
                _hidePopUpWidget('weather_details');
                _hidePopUpWidget('close_record_button');
                _hidePopUpWidget('close_weather_button');
                // TODO: Redirect to ride details screen.
              },
            ),
          ],
        ),
      ),
    );
  }
}
