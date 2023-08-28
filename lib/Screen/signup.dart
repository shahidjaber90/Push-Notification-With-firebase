import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pushnotifications/Screen/Login.dart';
import 'package:pushnotifications/Widgets/TextFieldWidget.dart';
import 'package:pushnotifications/Widgets/button.dart';
import 'package:pushnotifications/Widgets/passwordField_widget.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  var results;

  signup() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      users.add({
        'email': email.text,
        'password': password.text,
      });

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginView(),
          ));
      setState(() {
        isLoading = false;
      });
      email.clear();
      password.clear();

      // ignore: unnecessary_null_comparison
      if (users != null) {
        print("Account create successfully");
        setState(() {
          isLoading = false;
        });
        return users;
      } else {
        print("Account Failed");
        setState(() {
          isLoading = false;
        });
        return users;
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height * 1.00,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  LottieBuilder.asset('assets/lottie/signUp.json'),
                  Container(
                    child: Text(
                      "Create Account",
                      style: GoogleFonts.josefinSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1),
                    ),
                  ),
                  TextFieldWidget(
                      controller: email,
                      hintText: 'Enter Email . . .',
                      iconData: const Icon(
                        Icons.email,
                        color: Colors.white,
                      )),
                  PasswordFieldWidget(
                      controller: password,
                      hintText: 'Create Password . . .',
                      iconprefix: const Icon(Icons.lock, color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                                color: Colors.blue.shade800),
                          )
                        : ButtonWidget(buttonText: 'Sign Up', onTap: signup),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "If you have an Account",
                        style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            letterSpacing: 0.5),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginView()));
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.urbanist(
                                color: Colors.blue,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                letterSpacing: 0.5),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
