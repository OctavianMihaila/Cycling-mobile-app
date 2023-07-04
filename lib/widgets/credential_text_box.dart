import 'package:flutter/material.dart';

class CredentialTextBox extends StatelessWidget {
  final String text;
  final IconData iconData;
  final TextEditingController controller;

  const CredentialTextBox({
    required this.text,
    required this.iconData,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: width * 0.8,
      height: height * 0.07,
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.grey,
            ),
            SizedBox(
              width: width * 0.04,
            ),
            Expanded(
              child: TextField(
                controller: controller, // Assign the provided controller
                decoration: InputDecoration.collapsed(
                  hintText: text,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

