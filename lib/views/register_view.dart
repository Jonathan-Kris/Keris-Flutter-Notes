import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/constants/routes.dart';
import 'package:flutternotes/firebase_options.dart';
import 'package:flutternotes/helpers/colors.dart';
import 'package:flutternotes/widgets/custom_dialog.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
          title: const Text("Register"),
          backgroundColor: CustomColorPalette.appBarBackgroundColor),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder(
              future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return Column(
                      children: [
                        TextField(
                          controller: _email,
                          autocorrect: false,
                          enableSuggestions: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              hintText: "Enter your email"),
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
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password);
                              devtools.log(userCredential.toString());

                              // Send Email automatically after registering
                              final user = FirebaseAuth.instance.currentUser;
                              await user?.sendEmailVerification();

                              // Redirect to Verify Email View
                              if (context.mounted) {
                                Navigator.of(context)
                                    .pushNamed(verifyEmailRoute);
                              }
                            } on FirebaseAuthException catch (e) {
                              devtools.log(e.toString());
                              if (e.code == "weak-password") {
                                showErrorDialog(
                                    context: context,
                                    text:
                                        "Password is too weak! Password should be at least 6 characters");
                              } else if (e.code == "email-already-in-use") {
                                showErrorDialog(
                                    context: context,
                                    text:
                                        "The account already exists for that email.");
                              } else if (e.code == "invalid-email") {
                                showErrorDialog(
                                    context: context, text: "Invalid Email");
                              } else {
                                showErrorDialog(
                                    context: context,
                                    text: "Error: ${e.toString()}");
                              }
                            } catch (e) {
                              showErrorDialog(context: context);
                            }
                          },
                          child: const Text("Register"),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  loginRoute, (route) => false);
                            },
                            child: const Text("Already register? Login here")),
                      ],
                    );
                  default:
                    return const Column(children: [
                      CircularProgressIndicator(),
                      Text("Loading ...")
                    ]);
                }
              }),
        ),
      ),
    );
  }
}
