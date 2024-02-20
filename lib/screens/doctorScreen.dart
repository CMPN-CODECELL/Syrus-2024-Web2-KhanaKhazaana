import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syrus24/models/user_model.dart';
import 'package:syrus24/services/authService.dart';
import 'package:syrus24/widgets/custombutton.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../widgets/selectImage.dart';

class MyDoctorScreen extends StatefulWidget {
  static const routeName = '/mydoctor';
  const MyDoctorScreen({super.key});

  @override
  State<MyDoctorScreen> createState() => _MyDoctorScreenState();
}

class _MyDoctorScreenState extends State<MyDoctorScreen> {
  String lat = '';
  String long = '';
  ModelUser user = ModelUser(
      username: 'username',
      flatnumber: '',
      doctorAddress: '',
      doctorName: '',
      buildingName: '',
      streetName: '',
      city: '',
      doctorPhoto: '',
      userid: '',
      doctorPhone: '');
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  void getUser() async {
    setState(() {
      isLoading = true;
    });
    user = await AuthService().getUserDetails();
    setState(() {
      isLoading = false;
    });
  }

  void uploadImage() async {
    await AuthService().uploadDoctorPhoto(context: context, imagefile: img!);
    setState(() {});
  }

  void redirectToURL({required String query}) async {
    setState(() {
      _isLoading = true;
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.purple[100],
              ),
            );
          });
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) {
      //       return Scaffold(
      //         backgroundColor: Colors.transparent,
      //         body: Center(
      //           child: CircularProgressIndicator(
      //             color: greenColor,
      //           ),
      //         ),
      //       );
      //     }));
    });
    Position position = await determinePosition();
    setState(() {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      _isLoading = false;
      Navigator.of(context).pop();
    });
// This is the 255th attempt to try to understand what's happening
    //increase counter if you failed to understand
    //counter=255
    var url = Uri.parse(
        "https://www.google.com/maps/search/$query/@$lat,$long,15.25z?entry=ttu");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      print(e);
    }
  }

  Uint8List? img;
  bool _isLoading = false;
  void _selectImage() async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Select Image'),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  Uint8List _img = await getImage(source: ImageSource.camera);
                  setState(() {
                    img = _img;
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(child: Text('Upload from camera'))),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Uint8List _img = await getImage(source: ImageSource.gallery);
                  setState(() {
                    img = _img;
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(child: Text('Upload from gallery'))),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(child: Text('Cancel'))),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: (isLoading)
            ? Center(
                child: const CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : Column(
                children: [
                  Column(
                    children: [
                      (user.doctorPhoto.isEmpty)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(user.doctorPhoto),
                              ),
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      img != null
                                          ? CircleAvatar(
                                              radius: 64,
                                              backgroundImage:
                                                  MemoryImage(img!),
                                            )
                                          : CircleAvatar(
                                              radius: 64,
                                              backgroundImage: NetworkImage(
                                                  'https://randomuser.me/api/portraits/lego/5.jpg'),
                                            ),
                                      Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.blue,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.add_a_photo_rounded,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                                onPressed: _selectImage,
                                              )))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: CustomTextButton(
                                      color: Colors.purple,
                                      buttonTitle: 'Upload Photo',
                                      callback: () {
                                        if (img == null) {
                                          displaySnackbar(
                                              context: context,
                                              content: 'Select a photo!!');
                                        } else {
                                          uploadImage();
                                        }
                                      }),
                                )
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.purple[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Doctor name : ' + user.doctorName,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
                                      // style: GoogleFonts.getFont('Open Sans',
                                      //     fontSize: 20,
                                      //     fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Doctor address : ' + user.doctorAddress,
                                      // style: GoogleFonts.getFont('Open Sans',
                                      //     fontSize: 20,
                                      //     fontWeight: FontWeight.w400),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Doctor phone : ' + user.doctorPhone,
                                      // style: GoogleFonts.getFont('Open Sans',
                                      //     fontSize: 20,
                                      //     fontWeight: FontWeight.w400),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(height: 150, child: MedicineList()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Services near you',
                        style: GoogleFonts.getFont('Open Sans',
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: serviceNames.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ServiceCard(
                              callback: () {
                                redirectToURL(query: serviceNames[index]);
                              },
                              serviceTitle: serviceNames[index],
                              serviceImage: serviceImage[index],
                            ),
                          );
                        }),
                  )
                ],
              ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final VoidCallback callback;
  final String serviceTitle;
  final String serviceImage;
  const ServiceCard({
    super.key,
    required this.serviceTitle,
    required this.serviceImage,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(8),
          width: 180,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(serviceImage), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Text(
            serviceTitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class MedicineList extends StatelessWidget {
  final List<Map<String, String>> medicines = [
    {'timing': 'Breakfast', 'name': 'Aspirin'},
    {'timing': 'Breakfast', 'name': 'Paracetamol'},
    {'timing': 'Lunch', 'name': 'Lansoprazole'},
    {'timing': 'Lunch', 'name': 'Metformin'},
    {'timing': 'Dinner', 'name': 'Atorvastatin'},
    {'timing': 'Dinner', 'name': 'Simvastatin'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        return MedicineCard(
          timing: medicines[index]['timing']!,
          name: medicines[index]['name']!,
        );
      },
    );
  }
}

class MedicineCard extends StatelessWidget {
  final String timing;
  final String name;

  const MedicineCard({
    required this.timing,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Set the width of each card
      margin: EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timing,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}
