import 'package:flutter/material.dart';
import 'package:flutter_base/screens/onboard/view_model/login_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login_screen";

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Provider.of<LoginProvider>(context, listen: false).onSignUpClicked();
          },
          child: const Text("sign In"),
        ),
      ),
    );
  }
}
