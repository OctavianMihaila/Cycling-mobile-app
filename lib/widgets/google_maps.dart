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
            if (locationProvider.latitude == 0 &&
                locationProvider.longitude == 0) {
              locationProvider.fetchLocation();
            }

            // Consumer widget improves performance here by only
            // rebuilding the widget wrapped in it.
            return Consumer<LocationProvider>(
              builder: (context, locationProvider, _) {
                final double latitude = locationProvider.latitude;
                final double longitude = locationProvider.longitude;

                final CameraPosition initialCameraPosition = CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 18,
                );

                final GoogleMapController? controller =
                    locationProvider.controller;

                if (locationProvider.cameraMode == CameraMode.Follow) {
                  controller?.animateCamera(
                    CameraUpdate.newCameraPosition(initialCameraPosition),
                  );
                }

                return GoogleMap(
                  initialCameraPosition: initialCameraPosition,
                  myLocationEnabled: true,
                  polylines: locationProvider.polylines, // Use polylines from LocationProvider
                  onMapCreated: (controller) {
                    locationProvider.controller = controller;
                    locationProvider.startListeningForLocationChanges();
                  },
                  onCameraMove: (position) {},
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

