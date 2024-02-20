import 'package:flutter/material.dart';

import '../../ReminderService.dart';
import '../../constants.dart';
import '../../pages/contact.dart';
import '../../pages/image_rekognizer.dart';
import '../../pages/personal_info.dart';
import '../../pages/relative_galary.dart';
import '../../widgets/emotion_face.dart';

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

  int _selectedEvent = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        title: Text('Location Sharing'),
        actions: [
          IconButton(
              onPressed: () {
                _locationService.shareLocationWithEmergencyContacts();
              },
              icon: Icon(Icons.gps_fixed))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: ListView(
            children: [
              //greetings row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, Parth!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text('23 Jan,2021',
                          style: TextStyle(color: Colors.blue[200]))
                    ],
                  ),
                  //notification
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ))
                ],
              ),
              SizedBox(
                height: 25,
              ),
              //search bar
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Search',
                        style: TextStyle(
                          color: Colors.white,
                        ))
                  ],
                ),
              ),

              SizedBox(
                height: 25,
              ),

              //How do you feel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'How do you feel?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              //4 different faces
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      EmoticonFace(emoticonFace: '😔'),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'bad',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      EmoticonFace(emoticonFace: '🙂'),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'fine',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      EmoticonFace(emoticonFace: '😊'),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'well',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      EmoticonFace(emoticonFace: '🥳'),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Excellent',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Personal_Info(size: size),
              buildUserEvents(size),
              GalleryScreen()
            ],
          ),
        ),
      ),
    );
  }

  Container buildUserEvents(Size size) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: size.width / 1.8,
              padding: EdgeInsets.all(8),
              child: MaterialButton(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blue.shade700),
                ),
                color:
                    _selectedEvent == 0 ? Colors.blue.shade700 : Colors.white,
                onPressed: () {
                  setState(() {
                    _selectedEvent = 0;
                  });
                  _navigateToPage(0); // Navigate to Gallery screen
                },
                child: Text(
                  "Relatives",
                  style: TextStyle(
                    color: _selectedEvent == 0
                        ? Colors.white
                        : Colors.blue.shade700,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: size.width / 1.8,
              padding: EdgeInsets.all(8),
              child: MaterialButton(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blue.shade700),
                ),
                color:
                    _selectedEvent == 1 ? Colors.blue.shade700 : Colors.white,
                onPressed: () {
                  setState(() {
                    _selectedEvent = 1;
                  });
                  _navigateToPage(1); // Navigate to Contact page
                },
                child: Text(
                  "Contact",
                  style: TextStyle(
                    color: _selectedEvent == 1
                        ? Colors.white
                        : Colors.blue.shade700,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: size.width / 1.8,
              padding: EdgeInsets.all(8),
              child: MaterialButton(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blue.shade700),
                ),
                color:
                    _selectedEvent == 2 ? Colors.blue.shade700 : Colors.white,
                onPressed: () {
                  setState(() {
                    _selectedEvent = 2;
                  });
                  _navigateToPage(2); // Navigate to Image Recognizer page
                },
                child: Text(
                  "Recognize",
                  style: TextStyle(
                    color: _selectedEvent == 2
                        ? Colors.white
                        : Colors.blue.shade700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactList()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageRecognizer()),
        );
        break;
    }
  }
}
