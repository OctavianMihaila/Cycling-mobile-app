import 'package:cycling_route_planner/screens/auth/auth.dart';
import 'package:cycling_route_planner/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeWrapper extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return Container(
        child: HomeScreen(),
      );
    } else {
      return Container(
        child: AuthScreen(),
      );
    }
  }
}