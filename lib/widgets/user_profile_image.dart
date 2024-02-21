import 'package:flutter/material.dart';

Stack buildUserImage(Size size) {
  return Stack(
    children: [
      // * user profile image
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 3),
            shape: BoxShape.circle),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage("assets/linto.jpg"),
        ),
      ),
    ],
  );
}
