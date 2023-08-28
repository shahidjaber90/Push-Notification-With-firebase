import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TextFieldWidget extends StatelessWidget {
  String? hintText;
  TextEditingController controller;
  Icon iconData;
  TextFieldWidget(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SizedBox(
        height: 50,
        child: TextField(
          style: GoogleFonts.urbanist(
            fontSize: 18,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          controller: controller,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white),
              ),
              prefixIcon: iconData,
              hintText: hintText,
              hintStyle: GoogleFonts.urbanist(
                fontSize: 16,
                color: Colors.white,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w400,
              )),
        ),
      ),
    );
  }
}
