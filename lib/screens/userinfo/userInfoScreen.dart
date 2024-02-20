import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syrus24/services/authService.dart';

import '../../widgets/custombutton.dart';
import '../../widgets/customtextformfield.dart';
import '../home/exportHomeScreen.dart';

class UserInfoScreen extends StatefulWidget {
  static const String routeName = '/userinfo';
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final PageController pageController = PageController();
  int currentIndex = 0;
  void nextPage() {
    setState(() {
      currentIndex++;
    });
    if (currentIndex < 2) {
      pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
    }

    print(currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SingleChildScrollView(
            child: GetNameandAddress(callback: nextPage),
          ),
          SingleChildScrollView(
            child: GetDoctorDetails(callback: nextPage),
          ),
        ],
      ),
    );
  }
}

class GetNameandAddress extends StatefulWidget {
  final VoidCallback callback;
  const GetNameandAddress({super.key, required this.callback});

  @override
  State<GetNameandAddress> createState() => _GetNameandAddressState();
}

class _GetNameandAddressState extends State<GetNameandAddress> {
  final _signUpKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _flatController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  bool isLoading = false;
  void uploadDetailstoFirebase() async {
    setState(() {
      isLoading = true;
    });
    await AuthService().uploadUserDetails(
      username: _nameController.text.trim(),
      context: context,
      buildingName: _buildingController.text.trim(),
      flatnumber: _flatController.text.trim(),
      streetName: _streetController.text.trim(),
      city: _cityController.text.trim(),
    );
    setState(() {
      isLoading = false;
    });
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0, right: 10, left: 10),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Form(
              key: _signUpKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('Getting Started ',
                        style: GoogleFonts.getFont('Poppins',
                            fontSize: 35, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextInputField(
                    controller: _nameController,
                    hintText: 'Enter your name',
                    keyboardtype: TextInputType.name,
                    label: 'Name',
                  ),
                  CustomTextInputField(
                    controller: _flatController,
                    hintText: 'A-1402',
                    keyboardtype: TextInputType.name,
                    label: 'Flat Number',
                  ),
                  CustomTextInputField(
                    controller: _buildingController,
                    hintText: 'AshwaVilla',
                    keyboardtype: TextInputType.name,
                    label: 'Building',
                  ),
                  CustomTextInputField(
                    controller: _streetController,
                    hintText: '123, FakeStreet',
                    keyboardtype: TextInputType.name,
                    label: 'streetName',
                  ),
                  CustomTextInputField(
                    controller: _cityController,
                    hintText: 'Mumbai',
                    keyboardtype: TextInputType.name,
                    label: 'city',
                  ),
                  CustomTextButton(
                    buttonTitle: 'Submit',
                    callback: () {
                      if (_signUpKey.currentState!.validate()) {
                        uploadDetailstoFirebase();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GetDoctorDetails extends StatefulWidget {
  final VoidCallback callback;
  const GetDoctorDetails({super.key, required this.callback});

  @override
  State<GetDoctorDetails> createState() => _GetDoctorDetailsState();
}

class _GetDoctorDetailsState extends State<GetDoctorDetails> {
  final _signUpKey = GlobalKey<FormState>();
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _doctorAddressController =
      TextEditingController();
  final TextEditingController _doctorPhoneController = TextEditingController();

  bool isLoading = false;
  void uploadDoctorDetailstoFirebase() async {
    setState(() {
      isLoading = true;
    });
    await AuthService().uploadUserDoctorDetails(
        doctorName: _doctorNameController.text.trim(),
        context: context,
        doctorPhone: _doctorPhoneController.text.trim(),
        doctorAddress: _doctorAddressController.text.trim());
    setState(() {
      isLoading = false;
    });
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0, right: 10, left: 10),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Form(
              key: _signUpKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('About Your Doctor',
                        style: GoogleFonts.getFont('Poppins',
                            fontSize: 35, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextInputField(
                    controller: _doctorNameController,
                    hintText: 'abc',
                    keyboardtype: TextInputType.name,
                    label: 'Doctor\'s name',
                  ),
                  CustomTextInputField(
                    controller: _doctorAddressController,
                    hintText: '123 Fake Street',
                    keyboardtype: TextInputType.name,
                    label: 'Doctor\'s address',
                  ),
                  CustomTextInputField(
                    controller: _doctorPhoneController,
                    hintText: '1234567890',
                    keyboardtype: TextInputType.number,
                    label: 'Doctor\'s Phone',
                  ),
                  CustomTextButton(
                    buttonTitle: 'Submit',
                    callback: () {
                      if (_signUpKey.currentState!.validate()) {
                        uploadDoctorDetailstoFirebase();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
