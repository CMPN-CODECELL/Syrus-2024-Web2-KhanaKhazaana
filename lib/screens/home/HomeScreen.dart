import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syrus24/screens/auth/exportAuth.dart';

import '../../ReminderService.dart';
import '../../constants.dart';
import '../../pages.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ReminderService _reminderService = ReminderService();
  bool isLoading = false;
  double homeLat = 0;
  double homeLong = 0;
  bool _isNotificationSent = false;
  bool _isMounted = false;
  void startGeofencing(Function(Position) onEntry) {
    Geolocator.getPositionStream().listen((position) async {
      if (!_isMounted) return;
      setState(() {
        isLoading = true;
      });
      if (await isUserAtHome(position)) {
        onEntry(position);
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<bool> isUserAtHome(Position position) async {
    Position position = await determinePosition();
    setState(() {
      homeLat = position.latitude;
      homeLong = position.longitude;
      isLoading = false;
    });
    // Simulated home location (for demonstration purposes)
    // Calculate distance between current position and home location
    final double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      homeLat,
      homeLong,
    );
    // If the distance is less than 100 meters (adjust as needed), consider the user at home
    return distance < 100;
  }

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _initServices();
  }

  void _initServices() {
    startGeofencing(_onLocationEntry);
    _reminderService.initNotifications();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _onLocationEntry(Position position) {
    if (!_isNotificationSent) {
      _reminderService.showReminderNotification(
          reminderMessage: 'You have reached home!! Lock the doors properly');
      _isNotificationSent = true;
      // Reset notification flag after a delay (e.g., 1 hour)
      Timer(Duration(hours: 1), () {
        _isNotificationSent = false;
      });
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed(MyPhone.routeName);
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(
                Iconsax.logout,
                color: Colors.white,
              ))
        ],
        title: Text(
          'YaadonKiBaarat',
          style: GoogleFonts.getFont('Cabin',
              letterSpacing: 1.2,
              color: Colors.white,
              fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          elevation: 5,
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (Set<MaterialState> states) =>
                states.contains(MaterialState.selected)
                    ? GoogleFonts.getFont('Poppins',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)
                    : GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          child: NavigationBar(
            animationDuration: Duration(milliseconds: 50),
            selectedIndex: selectedIndex,
            indicatorColor: Colors.white60,
            backgroundColor: Colors.purple[300],
            onDestinationSelected: (newIndex) {
              setState(() {
                selectedIndex = newIndex;
              });
            },
            destinations: [
              NavigationItem(text: 'Home', icon: (Iconsax.home)),
              NavigationItem(text: 'Essentials', icon: (Iconsax.activity)),
              NavigationItem(text: 'My Doctor', icon: (Iconsax.health)),
              NavigationItem(text: 'Community', icon: (Iconsax.people)),
            ],
          ),
        ),
      ),
      body: pages[selectedIndex],
    );
  }
}

class NavigationItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const NavigationItem({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: Icon(
        icon,
        color: Colors.black,
        size: 25,
      ),
      label: text,
    );
  }
}
