import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:photo_sharing_app_with_firebase/home_screen/home_screen.dart';
import 'package:photo_sharing_app_with_firebase/widgets/button_square.dart';

class OwnerDetails extends StatefulWidget {
  String? img;
  String? userImg;
  String? userName;
  DateTime? date;
  String? docId;
  String? userId;
  int? downloads;

  OwnerDetails({
    Key? key,
    this.img,
    this.userImg,
    this.userName,
    this.date,
    this.docId,
    this.userId,
    this.downloads,
  }) : super(key: key);

  @override
  State<OwnerDetails> createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  int? total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink,
              Colors.deepOrange.shade300,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.2, 0.9],
          ),
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.red,
                  child: Column(
                    children: [
                      Image.network(
                        widget.img!,
                        width: MediaQuery.of(context).size.width,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
                const Text(
                  'Owner Information',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30.0),
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.userImg!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Uploaded by: ${widget.userName}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  DateFormat('dd MMMM, yyyy - hh:mm a')
                      .format(widget.date!)
                      .toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.download_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      " ${widget.downloads.toString()}",
                      style: const TextStyle(
                        fontSize: 28.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: ButtonSquare(
                    text: 'Download',
                    colors1: Colors.green,
                    colors2: Colors.lightGreen,
                    press: () async {
                      try {
                        var imageId =
                            await ImageDownloader.downloadImage(widget.img!);
                        if (imageId == null) {
                          return;
                        }
                        Fluttertoast.showToast(msg: 'Image Saved to Gallery');
                        total = widget.downloads! + 1;

                        FirebaseFirestore.instance
                            .collection('wallpaper')
                            .doc(widget.docId)
                            .update({
                          'downloads': total,
                        }).then((value) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => HomeScreen()));
                        });
                      } on PlatformException catch (error) {
                        print(error);
                      }
                    },
                  ),
                ),
                FirebaseAuth.instance.currentUser!.uid == widget.userId
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: ButtonSquare(
                          text: 'Delete',
                          colors1: Colors.green,
                          colors2: Colors.lightGreen,
                          press: () async {
                            FirebaseFirestore.instance
                                .collection('wallpaper')
                                .doc(widget.docId)
                                .delete()
                                .then(
                                  (value) => {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const HomeScreen(),
                                      ),
                                    )
                                  },
                                );
                          },
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: ButtonSquare(
                    text: 'Go Back',
                    colors1: Colors.green,
                    colors2: Colors.lightGreen,
                    press: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
