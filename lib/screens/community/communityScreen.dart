import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  static const routeName = '/community';
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [Text('Community')],
    ));
  }
}
