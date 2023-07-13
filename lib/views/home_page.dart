import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/firebase_options.dart';
import 'package:flutternotes/helpers/colors.dart';
import 'package:flutternotes/views/login_view.dart';
import 'package:flutternotes/views/verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Home Page"),
          backgroundColor: CustomColorPalette.appBarBackgroundColor),
          body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder(
            future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState){
                case ConnectionState.done:
                  User? user = FirebaseAuth.instance.currentUser;
                  final isUserVerified = user?.emailVerified ?? false;
                  print(user);

                  if (isUserVerified) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_box_rounded, color: Colors.green.shade300, size: 70.0,),
                          const Text("Firebase Initialization Done"),
                          const Text("User is verified")
                        ],
                      );

                      //return const LoginView();
                    } else {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const VerifyEmailView()));

                      return const VerifyEmailView();
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
      ),
    );
  }
}