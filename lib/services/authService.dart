import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syrus24/constants.dart';

import '../screens/Questionnaire/exportQuestionaire.dart';
import '../screens/auth/exportAuth.dart';

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
      await firestore
          .collection('users')
          .doc(user.uid)
          .set({"userid": user.uid, "phoneNumber": AuthService.phoneNumber});
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
      await firestore.collection('users').doc(user.uid).update({
        'username': username,
        'flatnumber': flatnumber,
        'buildingName': buildingName,
        'streetName': streetName,
        'city': city,
      });
    } catch (err) {
      displaySnackbar(context: context, content: 'Error occurred');
    }
  }

  Future<void> uploadUserDoctorDetails({
    required String doctorName,
    required BuildContext context,
    required String doctorAddress,
  }) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User user = firebaseAuth.currentUser!;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore
          .collection('users')
          .doc(user.uid)
          .update({'doctorName': doctorName, 'doctorAddress': doctorAddress});
    } catch (err) {
      displaySnackbar(context: context, content: 'Error occurred');
    }
  }
}
