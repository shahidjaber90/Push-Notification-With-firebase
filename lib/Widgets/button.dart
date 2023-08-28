import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  ButtonWidget({super.key, required this.buttonText, required this.onTap});
  String buttonText;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          height: 60,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black,
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                blurRadius: 6.0,
                spreadRadius: 1.0,
                offset: Offset(
                  0.05,
                  0.05,
                ),
              )
            ],
          ),
          child: Text(
            buttonText,
            style: GoogleFonts.gloock(
                letterSpacing: 2,
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w100),
          ),
        ),
      ),
    );
  }
}
