import 'package:flutter/material.dart';
import 'package:syrus24/models/user_model.dart';

import '../widgets/user_profile_image.dart';

class Personal_Info extends StatelessWidget {
  final Size size;
  final ModelUser user;
  const Personal_Info({super.key, required this.user, required this.size});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.deepPurple[400],
            borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildUserImage(size),
            Flexible(
              child: buildUserInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.username,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Age: 70",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Address : ${user.flatnumber} ${user.buildingName} ${user.city}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Phone : ${user.phoneNumber}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Emergency Contact: Jane Doe (+1 (555) 987-6543)",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          // Additional medical information can be added here
        ],
      ),
    );
  }
}
