import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:photo_sharing_app_with_firebase/log_in/login_screen.dart';
import 'package:photo_sharing_app_with_firebase/owner_details/owner_details.dart';
import 'package:photo_sharing_app_with_firebase/profile_screen/profile_screen.dart';
import 'package:photo_sharing_app_with_firebase/search_post/search_post.dart';

class UsersSpecificPostsScreen extends StatefulWidget {
  String? userId;
  String? userName;

  UsersSpecificPostsScreen({Key? key, this.userId, this.userName})
      : super(key: key);

  @override
  State<UsersSpecificPostsScreen> createState() =>
      _UsersSpecificPostsScreenState();
}

class _UsersSpecificPostsScreenState extends State<UsersSpecificPostsScreen> {
  String? myImage;
  String? myName;

  void read_userInfo() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userId)
        .get()
        .then<dynamic>(
      (DocumentSnapshot snapshot) async {
        myImage = snapshot.get('userImage');
        myName = snapshot.get('name');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    read_userInfo();
  }

  Widget listViewWidget(String docId, String img, String userImg,
      String userName, DateTime date, String userID, int downloads) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 16,
        shadowColor: Colors.white10,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pink,
                Colors.deepOrange.shade300,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [
                0.2,
                0.9,
              ],
            ),
          ),
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OwnerDetails(
                        img: img,
                        userImg: userImg,
                        userName: userName,
                        date: date,
                        docId: docId,
                        userId: userID,
                        downloads: downloads,
                      ),
                    ),
                  );
                },
                child: Image.network(
                  img,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 8.0,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                        userImg,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat("dd mmmm, yyyy - hhh:mm a")
                              .format(date)
                              .toString(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink,
            Colors.deepOrange.shade300,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [
            0.2,
            0.9,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepOrange.shade300,
                  Colors.pink,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [
                  0.2,
                  0.9,
                ],
              ),
            ),
          ),
          title: Text(widget.userName!),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.login_outlined,
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchPost(),
                  ),
                );
              },
              icon: const Icon(
                Icons.person_search,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.person,
              ),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('wallpaper')
              .where("id", isEqualTo: widget.userId)
              .orderBy('createAt', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return listViewWidget(
                      snapshot.data!.docs[index].id,
                      snapshot.data!.docs[index]['Image'],
                      snapshot.data!.docs[index]['userImage'],
                      snapshot.data!.docs[index]['userName'],
                      snapshot.data!.docs[index]['createAt'].toDate(),
                      snapshot.data!.docs[index]['id'],
                      snapshot.data!.docs[index]['downloads'],
                    );
                  },
                );
              }
            } else {
              return const Center(
                child: Text(
                  'There is no tasks',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }

            return const Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
