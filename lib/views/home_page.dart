import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/firebase_options.dart';
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
          child: 
          FutureBuilder(
            future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState){
                case ConnectionState.done:
                  User? user = FirebaseAuth.instance.currentUser;
                  final isUserVerified = user?.emailVerified ?? false;

                  if(user != null){
                    if (isUserVerified) {
                      // Main UI go here
                      return const NotesView();
                    } else {
                      //return const LoginView();
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
            }
          ),
        ),
      );
  }
}