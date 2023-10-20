import 'package:cycling_route_planner/services/elevation_provider.dart';
import 'package:cycling_route_planner/services/location_provider.dart';
import 'package:cycling_route_planner/services/ride_details_calculator.dart';
import 'package:cycling_route_planner/services/speed_provider.dart';
import 'package:cycling_route_planner/services/time_counter_provider.dart';
import 'package:cycling_route_planner/services/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cycling_route_planner/screens/home_wrapper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TimeCounterProvider>(
          create: (_) => TimeCounterProvider(),
        ),
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider<SpeedProvider>(
          create: (_) => SpeedProvider(),
        ),
        ChangeNotifierProvider<WeatherProvider>(
          create: (_) => WeatherProvider(),
        ),
        ChangeNotifierProvider<CaloriesBurnedProvider>(
          create: (_) => CaloriesBurnedProvider(),
        ),
        ChangeNotifierProvider<ElevationProvider>(
          create: (_) => ElevationProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeWrapper(),
    );
  }
}
