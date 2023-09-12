import 'package:cycling_route_planner/services/speed_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockChangeNotifier extends Mock implements ChangeNotifier {}

void main() {
  group('SpeedProvider Tests', () {
    late SpeedProvider speedProvider;
    MockChangeNotifier mockChangeNotifier;

    setUp(() {
      mockChangeNotifier = MockChangeNotifier();
      speedProvider = SpeedProvider();
      speedProvider.addListener(() {
        mockChangeNotifier.notifyListeners();
      });
    });

    test('Initial values should be zero', () {
      expect(speedProvider.currentSpeed, '0.00');
      expect(speedProvider.maxSpeed, '0.00');
      expect(speedProvider.averageSpeed, '0.0');
    });

    test('getCurrentSpeed should update current speed and max speed', () {
      speedProvider.getCurrentSpeed(5000, 3600);

      expect(speedProvider.currentSpeed, '5.00');
      expect(speedProvider.maxSpeed, '5.00');
    });

    test('getAverageSpeed should calculate average speed', () {
      speedProvider.getAverageSpeed(5000, 3600);

      expect(speedProvider.averageSpeed, '5.0');
    });
  });
}
