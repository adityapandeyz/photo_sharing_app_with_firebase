import 'package:flutter/material.dart';
import 'package:photo_sharing_app_with_firebase/search_post/users_specific_posts.dart';

import 'user.dart';

class UsersDesignWidget extends StatefulWidget {
  Users? model;
  BuildContext? context;

  UsersDesignWidget({
    Key? key,
    this.model,
    this.context,
  }) : super(key: key);

  @override
  State<UsersDesignWidget> createState() => _UsersDesignWidgetState();
}

class _UsersDesignWidgetState extends State<UsersDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UsersSpecificPostsScreen(
              userId: widget.model!.id,
              userName: widget.model!.name,
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: SizedBox(
            height: 240,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.amberAccent,
                  minRadius: 90,
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundImage: NetworkImage(
                      widget.model!.userImage!,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.model!.name!,
                  style: const TextStyle(
                    color: Colors.pink,
                    fontSize: 20,
                    fontFamily: 'Bebas',
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.model!.email!,
                  style: const TextStyle(
                    color: Colors.pink,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
