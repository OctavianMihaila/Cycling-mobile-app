import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ElevationProvider extends ChangeNotifier {
  double elevationGain = 0.0;
  double elevationLoss = 0.0;
  double previousElevation = 0.0;

  Future<void> fetchAndUpdateElevation(double latitude, double longitude) async {
    try {
      final url = 'https://api.open-elevation.com/api/v1/lookup?locations=$latitude,$longitude';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null && data['results'].isNotEmpty) {
          final currentElevation = data['results'][0]['elevation'].toDouble();
          updateElevation(currentElevation);
          notifyListeners();
        } else {
          print('No elevation data found in results');
        }
      } else {
        throw Exception('Failed to load elevation data');
      }
    } catch (e) {
      print('Failed to fetch or update elevation data: $e');
    }
  }

  void updateElevation(double currentElevation) {
    if (elevationGain == 0 && elevationLoss == 0) {
      previousElevation = currentElevation;
      elevationGain = currentElevation;
      elevationLoss = currentElevation;
    } else {
      double elevationChange = currentElevation - previousElevation;
      elevationGain += elevationChange > 0 ? elevationChange : 0;
      elevationLoss -= elevationChange < 0 ? elevationChange : 0;
      previousElevation = currentElevation;
    }
  }
}
