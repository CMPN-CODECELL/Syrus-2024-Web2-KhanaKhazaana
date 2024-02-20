import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/user_info_widget.dart';
import '../widgets/user_profile_image.dart';

class Personal_Info extends StatelessWidget {
  final Size size;
  const Personal_Info({super.key,
  required this.size});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blue[600],
            borderRadius: BorderRadius.circular(12)
        ),
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
}
