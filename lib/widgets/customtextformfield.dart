import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextInputField extends StatelessWidget {
  final TextEditingController controller;
  final keyboardtype;
  final String hintText;
  int maxLines;
  TextInputAction textInputAction;
  final String label;
  CustomTextInputField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.label,
      required this.keyboardtype,
      this.maxLines = 1,
      this.textInputAction = TextInputAction.next});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Enter your ${label}';
          }
          return null;
        },
        textInputAction: textInputAction,
        keyboardType: keyboardtype,
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          label: Text(
            label,
            style: GoogleFonts.getFont('Poppins',
                color: Colors.black, fontSize: 12),
          ),
          hintStyle: TextStyle(color: Colors.black45),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(20)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(20)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(20)),
          hintText: hintText,
        ),
      ),
    );
  }
}
