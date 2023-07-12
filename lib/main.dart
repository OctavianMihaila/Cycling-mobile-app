import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cycling_route_planner/screens/home_wrapper.dart';
import 'package:cycling_route_planner/utils/time_counter_provider.dart'; // Import the TimeCounterProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TimeCounterProvider>(
          create: (_) => TimeCounterProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeWrapper(),
    );
  }
}
