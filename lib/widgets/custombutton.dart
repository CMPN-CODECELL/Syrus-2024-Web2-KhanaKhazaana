import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback callback;
  final Color color;
  const CustomTextButton(
      {super.key,
      required this.buttonTitle,
      required this.callback,
      this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          minimumSize:
              MaterialStateProperty.all(const Size(double.infinity, 40)),
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),

        // style: ElevatedButton.styleFrom(
        //     backgroundColor: secondaryColor,
        //     minimumSize: const Size(double.infinity, 40),
        //     ),
        onPressed: callback,
        child: Text(
          buttonTitle,
          style: TextStyle(color: Colors.white),
        ));
  }
}
