import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class PasswordFieldWidget extends StatefulWidget {
  PasswordFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.iconprefix,
  });
  TextEditingController controller;
  String? hintText;
  Icon iconprefix;

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SizedBox(
        height: 50,
        child: TextField(
          style: GoogleFonts.urbanist(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              letterSpacing: 0.5),
          controller: widget.controller,
          obscureText: isObsecure,
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
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isObsecure = !isObsecure;
                    });
                  },
                  icon: isObsecure
                      ? Icon(
                          Icons.visibility_off,
                          color: Colors.grey.shade700,
                        )
                      : Icon(
                          Icons.visibility,
                          color: Colors.blue.shade800,
                        )),
            ),
            prefixIcon: widget.iconprefix,
            hintText: widget.hintText,
            hintStyle: GoogleFonts.urbanist(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }
}
