import 'package:cycling_route_planner/widgets/google_sign_in_button.dart';
import 'package:cycling_route_planner/widgets/popup_register_form.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';
import '../../widgets/credential_text_box.dart';
import '../../widgets/password_text_box.dart';
import '../../widgets/splash_button.dart';
import '../home_wrapper.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.yellow[800],
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        elevation: 0.0,
        title: const Text(
          'Sign in to Cycling peloton',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: height * 0.04),
                child: Image.asset(
                  'assets/images/sign_up_image.jpeg',
                  width: width,
                  height: height * 0.35,
                  fit: BoxFit.cover,
                )
            ),
            CredentialTextBox(
              text: 'example@email.com',
              iconData: Icons.email,
              controller: emailController,
            ),
            SizedBox(height: height * 0.02),
            CensoredCredentialTextBox(
              text: 'Your password',
              iconData: Icons.lock,
              controller: passwordController,
            ),
            SplashButton(
              text: 'Sign in',
              buttonColor: Colors.green,
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                await _auth.signInWithEmailAndPassword(email, password);

                redirectToFirstPage();
              },
              width: width * 0.8,
              height: height * 0.06,
            ),
            const Text(
              'Don not have an account?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GoogleSignInButton(
                  onPressed: () async {
                    dynamic result = await _auth.signInWithGoogle();
                    if (result == null) {
                      print('error signing in');
                    } else {
                      print('signed in as ${result.email}');
                      redirectToFirstPage();
                    }
                  },
                ),
                SplashButton(
                  text: 'Register',
                  buttonColor: Colors.grey[700]!,
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return RegisterForm(
                          height: height,
                          width: width,
                          hexColor: '#101415',
                        );
                      },
                    );
                  },
                  width: width * 0.25,
                  height: height * 0.053,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void redirectToFirstPage() {
    // Here we check if the context is mounted, because we are calling
    // setState() after a future has completed, and the context may no
    // longer be mounted at that point.
    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeWrapper()),
    );
  }
}
