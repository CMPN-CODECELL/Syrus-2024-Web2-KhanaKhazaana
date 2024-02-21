import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syrus24/screens/chats/chatScreen.dart';

import '../../widgets/postCard.dart';
import 'uploadImagesScreen.dart';

class CommunityScreen extends StatefulWidget {
  static const routeName = '/community';
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AddPostScreen.routeName);
          },
          child: Text(
            'Add Memories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('datePublished', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                      PostCard(snap: snapshot.data!.docs[index]));
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.deepPurple[200],
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ChatScreen.routeName);
              },
              icon: Icon(Iconsax.message),
            ),
          ),
        )
      ],
    );
  }
}
