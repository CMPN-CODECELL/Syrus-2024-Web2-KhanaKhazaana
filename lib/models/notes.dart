import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String uid;
  final String title;
  final String description;
  final Timestamp timestamp;
  final String audioPath;
  final String id;

  Note({
    required this.uid,
    required this.title,
    required this.id,
    required this.description,
    required this.timestamp,
    required this.audioPath,
  });

  static Note fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Note(
      uid: snapshot['userid'],
      title: snapshot['title'] ?? '',
      id: snapshot['id'],
      description: snapshot['description'],
      timestamp: snapshot['timestamp'],
      audioPath: snapshot['audioPath'] ?? '',
    );
  }
}
