import 'package:flutter/material.dart';
import 'package:photo_sharing_app_with_firebase/main.dart';

class AccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;

  const AccountCheck({
    Key? key,
    required this.login,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Don't have an Account?" : "Already have an Account",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Create Account" : "Log In",
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 50.0,
        )
      ],
    );
  }
}
