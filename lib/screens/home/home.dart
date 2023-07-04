import 'package:cycling_route_planner/screens/auth/auth.dart';
import 'package:cycling_route_planner/widgets/google_maps.dart';
import 'package:cycling_route_planner/widgets/popup_menu.dart';
import 'package:cycling_route_planner/widgets/splash_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text('Cycling peloton'),
        backgroundColor: Colors.orange[600],
      ),
      body: Material(
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: MapFromGoogle(),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.065,
              width: MediaQuery.of(context).size.width,
              color: Colors.orange[600],
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        // create a pop-up box
                      },
                      icon: Column(
                        children: [
                          Icon(
                            Icons.explore,
                            color: Colors.white,
                            size: 20,
                          ),
                          Text(
                            'Explore routes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        // Handle button 2 press
                      },
                      icon: Column(
                        children: [
                          Icon(
                            Icons.radar,
                            color: Colors.white,
                            size: 20,
                          ),
                          Text(
                            'Record',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        // Handle button 3 press
                      },
                      icon: Column(
                        children: [
                          Icon(
                            Icons.route,
                            color: Colors.white,
                            size: 20,
                          ),
                          Text(
                            'Create route',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
