import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cycling_route_planner/services/location.dart';

class MapFromGoogle extends StatefulWidget {
  @override
  _MapFromGoogleState createState() => _MapFromGoogleState();
}

class _MapFromGoogleState extends State<MapFromGoogle> {
  GoogleMapController? mapController;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    bool locationPermission = await location.checkLocationPermission();
    if (locationPermission) {
      await location.fetchLocation();
      setState(() => mapController?.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(location.getLatitude(), location.getLongitude()),
          14,
        )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(location.getLatitude(), location.getLongitude()),
        zoom: 14,
      ),
      onMapCreated: (controller) {
        setState(() {
          mapController = controller;
        });
        // Perform any controller-related operations here
        // Example: set map options, add markers, etc.
      },
    );
  }

  @override
  void dispose() {
    mapController?.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }
}
