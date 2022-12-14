import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_sharing_app_with_firebase/account_check/account_check.dart';
import 'package:photo_sharing_app_with_firebase/home_screen/home_screen.dart';
import 'package:photo_sharing_app_with_firebase/main.dart';
import 'package:photo_sharing_app_with_firebase/widgets/button_square.dart';
import 'package:photo_sharing_app_with_firebase/widgets/input_field.dart';

import '../../log_in/login_screen.dart';

class Credentials extends StatefulWidget {
  const Credentials({Key? key}) : super(key: key);

  @override
  State<Credentials> createState() => _CredentialsState();
}

class _CredentialsState extends State<Credentials> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _fullNameController =
      TextEditingController(text: "");
  final TextEditingController _emailTextController =
      TextEditingController(text: "");
  final TextEditingController _passTextController =
      TextEditingController(text: "");
  final TextEditingController _phoneNumController =
      TextEditingController(text: "");

  File? imagefile;
  String? imageUrl;

  void _showImageDialoge() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Please choose an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  _getFromCamera();
                },
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.camera,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  _getFromGallery();
                },
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.image,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        imagefile = File(croppedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _showImageDialoge();
            },
            child: CircleAvatar(
              radius: 90,
              backgroundImage: imagefile == null
                  ? const AssetImage('assets/images/avatar.png')
                  : Image.file(imagefile!).image,
            ),
          ),
          const SizedBox(height: 10.0),
          InputField(
            hintText: 'Enter Username',
            icon: Icons.person,
            obscureText: false,
            textEditingController: _fullNameController,
          ),
          const SizedBox(height: 10.0),
          InputField(
            hintText: 'Enter Email',
            icon: Icons.email_rounded,
            obscureText: false,
            textEditingController: _emailTextController,
          ),
          const SizedBox(height: 10.0),
          InputField(
            hintText: 'Enter Password',
            icon: Icons.lock_rounded,
            obscureText: true,
            textEditingController: _passTextController,
          ),
          const SizedBox(height: 10.0),
          InputField(
            hintText: 'Enter Phone Number',
            icon: Icons.phone_rounded,
            obscureText: false,
            textEditingController: _phoneNumController,
          ),
          const SizedBox(height: 15.0),
          ButtonSquare(
            text: 'Create Account',
            colors1: Colors.redAccent,
            colors2: Colors.red,
            press: (() async {
              if (imagefile == null) {
                Fluttertoast.showToast(msg: "Please select an Image");
                return;
              }
              try {
                final ref = FirebaseStorage.instance
                    .ref()
                    .child("userImages")
                    .child(DateTime.now().toString() + '.jpg');

                await ref.putFile(imagefile!);

                imageUrl = await ref.getDownloadURL();

                await _auth.createUserWithEmailAndPassword(
                  email: _emailTextController.text.trim().toString(),
                  password: _passTextController.text.trim(),
                );

                final User? user = _auth.currentUser;
                final _uid = user!.uid;

                FirebaseFirestore.instance.collection('Users').doc(_uid).set({
                  "id": _uid,
                  "userImage": imageUrl,
                  "name": _fullNameController.text,
                  "email": _emailTextController.text,
                  "phoneNumber": _phoneNumController.text,
                  "createAt": Timestamp.now(),
                });

                Navigator.canPop(context) ? Navigator.pop(context) : null;
              } catch (error) {
                Fluttertoast.showToast(
                  msg: error.toString(),
                );
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ),
              );
            }),
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
