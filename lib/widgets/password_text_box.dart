import 'package:flutter/material.dart';

import 'credential_text_box.dart';

class CensoredCredentialTextBox extends CredentialTextBox {
  const CensoredCredentialTextBox({
    required String text,
    required IconData iconData,
    required TextEditingController controller,
  }) : super(
    text: text,
    iconData: iconData,
    controller: controller,
  );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final textFieldWithModifications = TextField(
      controller: controller,
      obscureText: true,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration.collapsed(
        hintText: text,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );

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
            Expanded(child: textFieldWithModifications),
          ],
        ),
      ),
    );
  }
}
