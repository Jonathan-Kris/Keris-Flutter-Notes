import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/helpers/colors.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Center(
          child: Column(
        children: [
          const Text("Verify your email here"),
          TextButton(onPressed: () async {
            User? user = FirebaseAuth.instance.currentUser;
            print(user);
            await user?.sendEmailVerification();
          }, child: const Text("Send Email Verification"))],
      ));
  }
}