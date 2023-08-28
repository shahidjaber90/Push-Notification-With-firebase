import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pushnotifications/Screen/HomePage.dart';
import 'package:pushnotifications/Screen/Login.dart';

class Authpage extends StatelessWidget {
  const Authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream:FirebaseAuth.instance.authStateChanges() ,builder:(context, snapshot) {
        if(snapshot.hasData){
          return const HomePage();
        }else{
         return  const LoginView();
        }
      } , ),
    );
  }
}