import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:syrus24/constants.dart';

class QuestionNairService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> uploadQuestionnairResult(
      {required BuildContext context,
      required int totalScore,
      required String diagnosis}) async {
    final User? user = firebaseAuth.currentUser!;
    try {
      await firestore
          .collection('users')
          .doc(user!.uid)
          .update({"score": totalScore, "diagnosis": diagnosis});
    } catch (err) {
      displaySnackbar(context: context, content: 'Error uploading score');
    }
  }
}
