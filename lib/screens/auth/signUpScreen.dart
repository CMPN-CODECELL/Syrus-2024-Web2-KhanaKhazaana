import 'package:flutter/material.dart';
import 'package:syrus24/screens/home/exportHomeScreen.dart';
import 'package:syrus24/services/authService.dart';
import 'package:syrus24/widgets/custombutton.dart';
import 'package:syrus24/widgets/customtextformfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void signin() async {
    await AuthService().createUser(
        context: context,
        email: _nameController.text.trim(),
        password: _passwordController.text.trim());
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        CustomTextInputField(
            controller: _nameController,
            hintText: 'Email',
            label: 'Enter email',
            keyboardtype: TextInputType.text),
        CustomTextInputField(
            controller: _passwordController,
            hintText: 'password',
            label: 'Enter password',
            keyboardtype: TextInputType.text),
        CustomTextButton(
          buttonTitle: 'SignIn',
          callback: () {
            signin();
          },
        )
      ],
    ));
  }
}
