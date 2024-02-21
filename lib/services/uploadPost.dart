import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../models/posts_model.dart';
import 'uploadFiletoStorage.dart';

class FirestoreMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<String> uploadPost({
    required String description,
    required Uint8List image,
  }) async {
    String res = 'Some error occured';
    try {
      String photoUrl = await FileStorage().uploadImage('posts', image);
      String postId = Uuid().v1();
      final _post = Post(
        description: description,
        uid: firebaseAuth.currentUser!.uid,
        postId: postId,
        datePublished: Timestamp.now(),
        postUrl: photoUrl,
      );

      await firestore.collection('posts').doc(_post.postId).set(_post.toJson());
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
