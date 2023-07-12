import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../services/location_provider.dart';

class MapFromGoogle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final Future<bool> locationPermissionFuture =
    locationProvider.checkLocationPermission();

    return FutureBuilder<bool>(
      future: locationPermissionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (snapshot.data == true) {
            // Fetching the location if not already fetched
            if (locationProvider.latitude == 0 && locationProvider.longitude == 0) {
              locationProvider.fetchLocation();
            }
            // Consumer widget improves performance here by only
            // rebuilding the widget wrapped in it.
            return Consumer<LocationProvider>(
              builder: (context, locationProvider, _) {
                final double latitude = locationProvider.latitude;
                final double longitude = locationProvider.longitude;
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude),
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    // Perform any controller-related operations here
                    // Example: set map options, add markers, etc.
                  },
                );
              },
            );
          } else {
            return const Text('Location access denied');
          }
        }
      },
    );
  }
}
