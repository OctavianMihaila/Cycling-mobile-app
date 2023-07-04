import 'package:flutter/material.dart';

class SplashButton extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const SplashButton({
    required this.text,
    required this.buttonColor,
    required this.onPressed,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0), // Adjust the padding values as needed
      child: InkWell(
        splashColor: Colors.white,
        child: ElevatedButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(Size(width, height)),
            backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            elevation: MaterialStateProperty.all<double>(5.0),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
