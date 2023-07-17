import 'package:flutter/material.dart';
import 'package:flutternotes/constants/routes.dart';
import 'package:flutternotes/helpers/colors.dart';
import 'package:flutternotes/services/auth/auth_exceptions.dart';
import 'package:flutternotes/services/auth/auth_service.dart';
import 'package:flutternotes/widgets/custom_dialog.dart';

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
                                  .createUser(email: email, password: password);

                              // Send Email automatically after registering
                              await AuthService.firebase()
                                  .sendEmailNotification();

                              // Redirect to Verify Email View
                              if (context.mounted) {
                                Navigator.of(context)
                                    .pushNamed(verifyEmailRoute);
                              }
                            } on WeakPasswordAuthException {
                              await showErrorDialog(
                                  context: context,
                                  text:
                                      "Password is too weak! Password should be at least 6 characters");
                            } on EmailAlreadyInUsedAuthException {
                              showErrorDialog(
                                  context: context,
                                  text:
                                      "The account already exists for that email.");
                            } on InvalidEmailAuthException {
                              showErrorDialog(
                                  context: context, text: "Invalid Email");
                            } on GenericAuthException catch (e) {
                              showErrorDialog(
                                  context: context,
                                  text: "Error: ${e.toString()}");
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
