import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:syrus24/constants.dart';
import 'package:syrus24/errorHandling.dart';

class SendLocation {
  Future<void> sendmessage(
      {required BuildContext context,
      required String lat,
      required String number,
      required String lon,
      required String username}) async {
    try {
      String url = 'https://8800-115-98-232-52.ngrok-free.app/send-sms';
      http.Response res = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "text": "User $username is currently at lat:$lat, long : $lon",
            "number": number
          }));
      httpErrorHandle(
          res: res,
          context: context,
          onSuccess: () {
            displaySnackbar(
                context: context, content: 'your location shared with $number');
          });
    } catch (err) {
      print(err.toString());
    }
  }
}
