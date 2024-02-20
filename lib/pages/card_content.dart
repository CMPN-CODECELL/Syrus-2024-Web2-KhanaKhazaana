import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {
  final String name;
  final String date;

  const CardContent({super.key, 
    required this.name,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(name, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text(
            date,
            style: const TextStyle(color: Colors.grey),
          ),


        ],
      ),
    );
  }
}
