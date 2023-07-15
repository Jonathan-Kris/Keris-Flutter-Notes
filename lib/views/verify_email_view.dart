import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/helpers/colors.dart';
import 'dart:developer' as devtools show log;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Verify Email"),
          backgroundColor: CustomColorPalette.appBarBackgroundColor),
      body: Center(
          child: Column(
        children: [
          const Text("Verify your email here"),
          TextButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                devtools.log(user.toString());
                
                final isUserVerified = user?.emailVerified ?? false;

                if(!isUserVerified){
                  await user?.sendEmailVerification();
                }
                
                Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);

              },
              child: const Text("Send Email Verification"))
        ],
      )),
    );
  }
}