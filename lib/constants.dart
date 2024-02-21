import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:syrus24/services/sendLocationMessage.dart';

displaySnackbar({required BuildContext context, required String content}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      content,
      textAlign: TextAlign.center,
      style: GoogleFonts.getFont('Lato',
          fontWeight: FontWeight.w800, fontSize: 18),
    ),
    backgroundColor: Colors.deepPurple[100],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
  ));
}

final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: Color.fromRGBO(234, 239, 243, 1), width: 2),
    borderRadius: BorderRadius.circular(20),
  ),
);

final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
  borderRadius: BorderRadius.circular(20),
);

final submittedPinTheme = defaultPinTheme.copyWith(
  decoration: defaultPinTheme.decoration?.copyWith(
    color: Color.fromRGBO(234, 239, 243, 1),
    borderRadius: BorderRadius.circular(20),
  ),
);

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  try {
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }

    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  } catch (e) {
    // Log the error for debugging
    print('Error in determinePosition: $e');
    // Return null or throw the error depending on your use case
    return Future.error(e.toString());
  }
}

class LocationService {
  Future<bool> isUserAtHome(Position position) async {
    // Simulated home location (for demonstration purposes)
    final double homeLat = 37.7749;
    final double homeLong = -122.4194;

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

  Future<void> shareLocationWithEmergencyContacts(
      {required BuildContext context, required String username}) async {
    // Simulated emergency contacts
    List<String> emergencyContacts = ['8591870313', '9324309587'];

    // Get user's current location
    Position position = await Geolocator.getCurrentPosition();

    // Generate Google Maps link with user's location
    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

    // Create a message containing the Google Maps link
    String message = '$googleMapsUrl';
    String googleUrlEncoded = Uri.encodeComponent(googleMapsUrl);
    String phone = emergencyContacts.join(",");
    print(phone);
    // Construct the message with the Google Maps URL
    message = "I am currently at this location:\n$googleUrlEncoded";
    // Generate WhatsApp message URL
    String url = "https://wa.me/${emergencyContacts[0]}/?text=$message";

    // Launch WhatsApp with pre-filled message
    // if (await canLaunchUrl(Uri.parse(url))) {
    //   await launchUrl(Uri.parse(url));
    // } else {
    //   throw 'Could not launch WhatsApp.';
    // }
    await SendLocation().sendmessage(
        context: context,
        lat: position.latitude.toString(),
        number: '9324309587',
        lon: position.longitude.toString(),
        username: username);
  }

  void startGeofencing(Function(Position) onEntry) {
    Geolocator.getPositionStream().listen((position) async {
      onEntry(position);
    });
  }
}

List<String> serviceNames = [
  "Hospitals",
  "Pathology Labs",
  "Chemists",
];

List<String> serviceImage = [
  'assets/hospital.jpg',
  'assets/pathology.jpg',
  'assets/pharmacy.jpg',
];
