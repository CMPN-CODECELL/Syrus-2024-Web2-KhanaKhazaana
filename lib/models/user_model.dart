import 'package:cloud_firestore/cloud_firestore.dart';

class ModelUser {
  final String username;
  final String flatnumber;
  final String buildingName;
  final String streetName;
  final String city;
  final String uid;
  final String doctorName;
  final String doctorAddress;

  ModelUser(
      {required this.username,
      required this.flatnumber,
      required this.doctorAddress,
      required this.doctorName,
      required this.buildingName,
      required this.streetName,
      required this.city,
      required this.uid});

  Map<String, dynamic> toJson() => {
        'username': username,
        'flatnumber': flatnumber,
        'buildingName': buildingName,
        'streetName': streetName,
        'city': city,
        'uid': uid,
        'doctorName': doctorName,
        'doctorAddress': doctorAddress
      };

  static ModelUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelUser(
        doctorName: snapshot['doctorName'],
        doctorAddress: snapshot['doctorAddress'],
        username: snapshot['username'],
        flatnumber: snapshot['flatnumber'],
        buildingName: snapshot['buildingName'],
        streetName: snapshot['streetName'],
        city: snapshot['city'],
        uid: snapshot['uid']);
  }
}
