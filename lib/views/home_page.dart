import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/firebase_options.dart';
import 'package:flutternotes/helpers/colors.dart';
import 'package:flutternotes/widgets/custom_dialog.dart';

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
                  final _isUserVerified = user?.emailVerified ?? false;
                  print(user);

                  if (_isUserVerified) {
                    print("Your email is verified");
                  }
                  else {
                    print("You need to verify your email first");
                  }
                  
                  return const Text("Firebase Initialization Done");
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