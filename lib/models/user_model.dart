import 'package:cloud_firestore/cloud_firestore.dart';

class ModelUser {
  final String username;
  final String flatnumber;
  final String buildingName;
  final String streetName;
  final String city;
  final String userid;
  final String doctorName;
  final String doctorAddress;
  final String doctorPhoto;
  final String doctorPhone;

  ModelUser(
      {required this.username,
      required this.flatnumber,
      required this.doctorAddress,
      required this.doctorName,
      required this.buildingName,
      required this.streetName,
      required this.city,
      required this.doctorPhoto,
      required this.doctorPhone,
      required this.userid});

  Map<String, dynamic> toJson() => {
        'username': username,
        'flatnumber': flatnumber,
        'buildingName': buildingName,
        'streetName': streetName,
        'city': city,
        'userid': userid,
        'doctorPhoto': doctorPhoto,
        'doctorName': doctorName,
        'doctorAddress': doctorAddress,
        'doctorPhone': doctorPhone
      };

  static ModelUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelUser(
        doctorName: snapshot['doctorName'],
        doctorPhoto: snapshot['doctorPhoto'] ?? '',
        doctorAddress: snapshot['doctorAddress'],
        username: snapshot['username'],
        flatnumber: snapshot['flatnumber'],
        buildingName: snapshot['buildingName'],
        doctorPhone: snapshot['doctorPhone'] ?? '',
        streetName: snapshot['streetName'],
        city: snapshot['city'],
        userid: snapshot['userid']);
  }
}
