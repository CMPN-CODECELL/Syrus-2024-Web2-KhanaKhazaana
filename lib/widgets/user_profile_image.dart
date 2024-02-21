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
          backgroundImage: NetworkImage(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSATP5C4Iti8iYFIwldjqZA3Tz_6efOBTvQCHc8xIL-WQkkLQ&s"),
        ),
      ),
    ],
  );
}
