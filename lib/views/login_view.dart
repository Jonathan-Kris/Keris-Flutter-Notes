import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/firebase_options.dart';
import 'package:flutternotes/helpers/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutternotes/widgets/custom_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Login"),
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
                    return Column(
                      children: [
                        TextField(
                          controller: _email,
                          autocorrect: false,
                          enableSuggestions: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(hintText: "Enter your email"),
                        ),
                        TextField(
                            controller: _password,
                            obscureText: true,
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: const InputDecoration(
                              hintText: "Enter your password",
                            )),
                        TextButton(
                          onPressed: () async {
                
                            final email = _email.text;
                            final password = _password.text;
                
                            try {
                              final userCredential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);
    
                              print(userCredential);
    
                              showSuccessDialog(context: context, text: "Welcome ${email}");
                            } on FirebaseAuthException catch (e) {
                              print(e);
                              if(e.code == "user-not-found"){
                                showErrorDialog(context: context, text: "User not found!");
                              }
                              else if (e.code == "wrong-password"){
                                showErrorDialog(context: context, text: "Your data doesn't match any record in our database");
                              }
                              else if (e.code == "too-many-requests"){
                                showErrorDialog(context: context, text: "This account has been temporarily disabled due to many failed login attempts. Try again later");
                              }
                            } catch (e){
                              print(e);
                                showErrorDialog(context: context);
                            }
                
                          },
                          child: const Text("Login"),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "/register", (route) => false);
                            }, 
                        child: const Text("Don't have an account? Register here"))
                      ],
                    );
                  default:
                   return const Column(children: [
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
