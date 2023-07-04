import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import the Firebase Core package
import 'package:cycling_route_planner/screens/home_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeWrapper(),
    );
  }
}
