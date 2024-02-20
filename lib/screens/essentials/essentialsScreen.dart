import 'package:flutter/material.dart';

import '../../ReminderService.dart';
import '../../constants.dart';

class EssentialScreen extends StatefulWidget {
  static const routeName = '/essential';
  const EssentialScreen({super.key});

  @override
  State<EssentialScreen> createState() => _EssentialScreenState();
}

class _EssentialScreenState extends State<EssentialScreen> {
  final LocationService _locationService = LocationService();
  final ReminderService _notificationService = ReminderService();

  bool _isUserAtHome = false; // Simulated home location for demonstration

  @override
  void initState() {
    super.initState();
    _locationService.startGeofencing((position) async {
      if (await _locationService.isUserAtHome(position)) {
        setState(() {
          _isUserAtHome = true;
        });
      } else {
        _notificationService.scheduleNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Sharing'),
      ),
      body: Center(
        child: _isUserAtHome
            ? Text('You are at home.')
            : ElevatedButton(
                onPressed: () {
                  _locationService.shareLocationWithEmergencyContacts();
                },
                child: Text('Share Location'),
              ),
      ),
    );
  }
}
