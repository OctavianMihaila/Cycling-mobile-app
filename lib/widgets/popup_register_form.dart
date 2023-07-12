import 'package:cycling_route_planner/widgets/password_text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cycling_route_planner/widgets/splash_button.dart';
import 'package:cycling_route_planner/services/register.dart';

import '../screens/home/home.dart';
import '../services/auth.dart';
import 'credential_text_box.dart';

class RegisterForm extends StatefulWidget {
  final double height;
  final double width;
  final String hexColor;

  const RegisterForm({
    required this.height,
    required this.width,
    required this.hexColor,
  });

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // This is called when the stateful widget is removed from the tree
  // permanently in order to prevent memory leaks.
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _register() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    UserCredential? result = RegisterService().registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    ) as UserCredential?;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Please try again.')),
      );

      // Dispose of the text controllers in order to prevent memory leaks.
      dispose();
      return false;
    } else {
      // Sign in the user and redirect to the home page.
      AuthService().signInWithEmailAndPassword(email, password);

      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(int.parse(widget.hexColor.substring(1, 7), radix: 16) + 0xFF000000),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: Container(
          height: widget.height * 0.52,
          decoration: BoxDecoration(
            color: Colors.orange[600],
            border: Border.all(width: 0, color: Colors.transparent),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              CredentialTextBox(
                text: 'Your name',
                iconData: Icons.person,
                controller: nameController,
              ),
              const SizedBox(height: 20.0),
              CredentialTextBox(
                text: 'Your email',
                iconData: Icons.email,
                controller: emailController,
              ),
              const SizedBox(height: 20.0),
              CensoredCredentialTextBox(
                text: 'Your password',
                iconData: Icons.lock,
                controller: passwordController,
              ),
              const SizedBox(height: 20.0),
              SplashButton(
                text: 'Register',
                buttonColor: Colors.grey[600]!,
                onPressed: () {
                  if (_register()) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }
                },
                width: widget.width * 0.8,
                height: widget.height * 0.06,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
