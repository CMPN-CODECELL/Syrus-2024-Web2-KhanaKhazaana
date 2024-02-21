import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String postId;
  final Timestamp datePublished;
  final String postUrl;

  const Post({
    required this.description,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot["description"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      postUrl: snapshot['postUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
      };
}
