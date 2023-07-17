import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/services/auth/auth_service.dart';
import 'package:flutternotes/services/auth/auth_user.dart';
import 'package:flutternotes/views/login_view.dart';
import 'package:flutternotes/views/notes_view.dart';
import 'package:flutternotes/views/verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder(
            future: AuthService.firebase().initialize(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final user = AuthService.firebase().currentUser;

                  if (user != null) {
                    if (user.isEmailVerified) {
                      // Main UI go here
                      return const NotesView();
                    } else {
                      return const VerifyEmailView();
                    }
                  } else {
                    return const LoginView();
                  }
                default:
                  return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text("Loading ...")
                      ]);
              }
            }),
      ),
    );
  }
}
