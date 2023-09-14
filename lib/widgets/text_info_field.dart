import 'package:flutter/material.dart';

class TextInfoField extends StatelessWidget {
  final String fieldName;
  final String fieldValue;

  const TextInfoField({
    required this.fieldName,
    required this.fieldValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            fieldName,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            fieldValue,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
