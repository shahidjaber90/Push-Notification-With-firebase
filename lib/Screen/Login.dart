import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pushnotifications/Screen/HomePage.dart';
import 'package:pushnotifications/Screen/signup.dart';
import 'package:pushnotifications/Widgets/TextFieldWidget.dart';
import 'package:pushnotifications/Widgets/button.dart';
import 'package:pushnotifications/Widgets/passwordField_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;
  login() async {
    setState(() {
      isLoading = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
      if (auth.currentUser != null) {
        final currentUsers = auth.currentUser!.email.toString();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('currentUser', currentUsers);
        print('User email: $currentUsers');
      }
      setState(() {
        isLoading = false;
      });
      email.clear();
      password.clear();
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
      // ignore: use_build_context_synchronously
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              e.message.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          );
        },
      );
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
                      "Login",
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
                      iconprefix: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      )),
                  isLoading
                      ? Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Center(
                            child: CircularProgressIndicator(
                                color: Colors.blue.shade800),
                          ),
                        )
                      : ButtonWidget(buttonText: 'Sign In', onTap: login),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an Account",
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
                                    builder: (context) => const SignUpView()));
                          },
                          child: Text(
                            "SignUp",
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
