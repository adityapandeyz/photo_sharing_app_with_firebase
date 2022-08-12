import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_sharing_app_with_firebase/account_check/account_check.dart';
import 'package:photo_sharing_app_with_firebase/log_in/login_screen.dart';
import 'package:photo_sharing_app_with_firebase/widgets/button_square.dart';
import 'package:photo_sharing_app_with_firebase/widgets/input_field.dart';

import '../../sign_up/sing_up_screen.dart';

class Credentials extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailTextController =
      TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Center(
              child: Image.asset(
                "assets/images/forget.png",
                width: 300.0,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          InputField(
            hintText: "Enter Email",
            icon: Icons.email_rounded,
            obscureText: false,
            textEditingController: _emailTextController,
          ),
          const SizedBox(height: 15.0),
          ButtonSquare(
            text: "Send Link",
            colors1: Colors.red,
            colors2: Colors.redAccent,
            press: () async {
              try {
                await _auth.sendPasswordResetEmail(
                    email: _emailTextController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.amber,
                    content: Text(
                      'Password Reset email has been sent!',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                );
              } on FirebaseAuthException catch (error) {
                Fluttertoast.showToast(
                  msg: error.toString(),
                );
              }
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const SignUpScreen(),
                ),
              );
            },
            child: const Center(
              child: Text(
                'Create Account',
              ),
            ),
          ),
          AccountCheck(
            login: false,
            press: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
