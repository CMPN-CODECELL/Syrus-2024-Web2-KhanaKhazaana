import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syrus24/constants.dart';

import '../models/user_model.dart';
import '../screens/Questionnaire/exportQuestionaire.dart';
import '../screens/auth/exportAuth.dart';
import 'uploadFiletoStorage.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static late String verificationId;
  static late String phoneNumber;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> getPhoneNumber(
      {required BuildContext context, required String phoneNumber}) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          AuthService.verificationId = verificationId;
          print('verificationId ' + AuthService.verificationId);
          AuthService.phoneNumber = phoneNumber;
          Navigator.pushNamed(context, MyVerify.routeName);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          displaySnackbar(context: context, content: 'error');
        },
      );
    } on FirebaseAuthException catch (err) {
      displaySnackbar(context: context, content: err.toString());
    }
  }

  Future<void> verifyOtp(
      {required BuildContext context, required String pin}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: pin);
      await firebaseAuth.signInWithCredential(credential);
      await AuthService().uploadPhoneNumber(
          context: context, phoneNumber: AuthService.phoneNumber);
      Navigator.pushNamedAndRemoveUntil(
          context, QuestionnairePage.routeName, (route) => false);
    } catch (err) {
      displaySnackbar(context: context, content: 'Invalid Otp');
    }
  }

  Future<void> uploadPhoneNumber(
      {required BuildContext context, required String phoneNumber}) async {
    User? user = firebaseAuth.currentUser!;
    try {
      await firestore.collection('users').doc(user.uid).set({
        "userid": user.uid,
        "phoneNumber": AuthService.phoneNumber,
        "doctorPhoto": ""
      });
    } catch (err) {
      displaySnackbar(context: context, content: 'Some error occurred');
    }
  }

  Future<void> uploadUserDetails({
    required String username,
    required BuildContext context,
    required String buildingName,
    required String flatnumber,
    required String streetName,
    required String city,
  }) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User user = firebaseAuth.currentUser!;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      String image =
          'https://firebasestorage.googleapis.com/v0/b/syrus24-91e8e.appspot.com/o/doctorPhoto%2FyiRG9RHrEIXKO6fOQytHeJAHBjD3%2F213bde80-0832-1eca-ab51-e3ae39e63566?alt=media&token=e22c677b-7775-436e-bcf2-e4fd9576bb92';
      await firestore.collection('users').doc(user.uid).update({
        'username': username,
        'flatnumber': flatnumber,
        'buildingName': buildingName,
        'streetName': streetName,
        'city': city,
        'relationName': ['aditya', 'linto'],
        'relationImage': [image, image]
      });
    } catch (err) {
      displaySnackbar(context: context, content: 'Error occurred');
    }
  }

  Future<void> uploadUserDoctorDetails(
      {required String doctorName,
      required BuildContext context,
      required String doctorAddress,
      required String doctorPhone}) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User user = firebaseAuth.currentUser!;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('users').doc(user.uid).update({
        'doctorName': doctorName,
        'doctorAddress': doctorAddress,
        "doctorPhone": doctorPhone
      });
    } catch (err) {
      displaySnackbar(context: context, content: 'Error occurred');
    }
  }

  Future<ModelUser> getUserDetails() async {
    User currentUser = firebaseAuth.currentUser!;
    DocumentSnapshot snap =
        await firestore.collection('users').doc(currentUser.uid).get();
    return ModelUser.fromSnap(snap);
  }

  Future<void> uploadDoctorPhoto(
      {required BuildContext context, required Uint8List imagefile}) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User user = firebaseAuth.currentUser!;
    try {
      String photoUrl =
          await FileStorage().uploadImage('doctorPhoto', imagefile);

      await firestore
          .collection('users')
          .doc(user.uid)
          .update({"doctorPhoto": photoUrl});
    } catch (err) {
      displaySnackbar(context: context, content: 'Error occurred');
    }
  }

  Future<void> createUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      await uploadtodatabase(context: context);
    } catch (err) {
      displaySnackbar(context: context, content: 'Error');
    }
  }

  Future<void> uploadtodatabase({required BuildContext context}) async {
    try {
      String doctorPhoto =
          'https://firebasestorage.googleapis.com/v0/b/syrus24-91e8e.appspot.com/o/doctorPhoto%2FyiRG9RHrEIXKO6fOQytHeJAHBjD3%2F213bde80-0832-1eca-ab51-e3ae39e63566?alt=media&token=e22c677b-7775-436e-bcf2-e4fd9576bb92';
      ModelUser user = ModelUser(
          username: 'aditya',
          flatnumber: 'flatnumber',
          doctorAddress: 'doctorAddress',
          doctorName: 'doctorName',
          buildingName: 'buildingName',
          streetName: 'streetName',
          city: 'city',
          doctorPhoto: doctorPhoto,
          doctorPhone: '1234567890',
          userid: firebaseAuth.currentUser!.uid,
          phoneNumber: '1234567890',
          relationImage: [],
          relationName: []);
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set(user.toJson());
    } catch (err) {
      displaySnackbar(context: context, content: err.toString());
    }
  }
}
