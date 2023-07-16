import 'dart:ui';

import 'package:cycling_route_planner/services/location_provider.dart';
import 'package:cycling_route_planner/services/speed_provider.dart';
import 'package:cycling_route_planner/services/time_counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cycling_route_planner/screens/home_wrapper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FlutterError.presentError = (FlutterErrorDetails details) {
  //   print('##################..Caught error: ${details.exception}');
  //   if (details.exception is FlutterError &&
  //       details.stack.toString().contains('GLThread')) {
  //     print('>>>>>>>>>>>>>>>>>>>>>>>>>..Caught GLThread exception');
  //
  //
  //     return;
  //   }

  PlatformDispatcher.instance.onError = (error, stack) {
    print('##################..Caught error: $error');

    return true;
  };

    // // Let the default error handling continue
    // FlutterError.presentError(details);
  // };

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
