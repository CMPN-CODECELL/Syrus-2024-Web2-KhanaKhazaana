import 'package:flutter/material.dart';

Padding buildUserInfo() {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Parth Wande",
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
          "Address: 1234 Memory Lane, Alzheimer's City",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "Contact: +1 (555) 123-4567",
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
