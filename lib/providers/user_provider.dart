// import 'package:flutter/foundation.dart';
//
// import '../models/user_model.dart';
//
// class UserProvider extends ChangeNotifier {
//   ModelUser? _user;
//   ModelUser get getUser => _user!;
//
//   final Auth _auth = Auth();
//
//   Future<void> refreshUser() async {
//     ModelUser user = await _auth.getUserDetails();
//     _user = user;
//     print('eeeeeee' + user.username);
//     notifyListeners();
//   }
// }
