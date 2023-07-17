import 'package:flutter/material.dart';
import 'package:flutternotes/constants/routes.dart';
import 'package:flutternotes/helpers/colors.dart';
import 'package:flutternotes/services/auth/auth_exceptions.dart';
import 'package:flutternotes/services/auth/auth_service.dart';
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
              future: AuthService.firebase().initialize(),
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
                              await AuthService.firebase()
                                  .login(email: email, password: password);
                              final user = AuthService.firebase().currentUser;

                              if (context.mounted) {
                                if (user?.isEmailVerified ?? false) {
                                  // Main UI go here
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      notesRoute, (route) => false);
                                } else {
                                  Navigator.of(context)
                                      .pushNamed(verifyEmailRoute);
                                }
                              }
                            } on UserNotFoundAuthException {
                              await showErrorDialogVandad(
                                  context: context, text: "User not found!");
                            } on WrongPasswordAuthException {
                              await showErrorDialog(
                                  context: context,
                                  text: "Incorrect password!");
                            } on TooManyRequestAuthException {
                              await showErrorDialog(
                                  context: context,
                                  text:
                                      "This account has been temporarily disabled due to many failed login attempts. Try again later");
                            } on GenericAuthException catch (e) {
                              await showErrorDialog(
                                  context: context,
                                  text:
                                      "Authentication Error: ${e.toString()}");
                            }
                          },
                          child: const Text("Login"),
                        ),
                        TextButton(
                            onPressed: () {
                              //Navigator.of(context).pushNamed(registerRoute);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                registerRoute,
                                (route) => false,
                              );
                            },
                            child: const Text(
                                "Don't have an account? Register here"))
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
