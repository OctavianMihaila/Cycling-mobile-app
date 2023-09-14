import 'package:flutter/material.dart';

class IconTextInfoField extends StatelessWidget {
  final String fieldValue;
  final IconData iconData;

  IconTextInfoField({
    required this.fieldValue,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: 30, // Adjust the size of the icon as needed
          color: Colors.blue, // Set the desired icon color
        ),
        const SizedBox(height: 16), // Spacer between icon and value
        Container(
          child: Text(
            fieldValue,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.orange,
                decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
