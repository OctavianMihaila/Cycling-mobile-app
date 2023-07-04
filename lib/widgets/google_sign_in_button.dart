import 'package:cycling_route_planner/widgets/splash_button.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends SplashButton {
  GoogleSignInButton({
    required VoidCallback onPressed,
  }) : super(
    text: 'Sign in with Google',
    buttonColor: Colors.blue,
    onPressed: onPressed,
    width: 300.0,
    height: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        splashColor: Colors.white,
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.g_mobiledata_sharp,
                size: 24.0,
                color: Colors.white,
              ),
              const SizedBox(width: 8.0),
              Text(
                text,
                style: const TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
