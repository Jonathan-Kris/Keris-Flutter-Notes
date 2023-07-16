import 'package:flutter/material.dart';

Future<void> showErrorDialog(
    {required BuildContext context, String? text}) async {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            alignment: Alignment.center,
            child: SizedBox(
                height: 100.0,
                width: 80.0,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    Text(
                      text ?? "An error has occured",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ))));
      });
}

Future<void> showErrorDialogVandad(
    {required BuildContext context, required String text}) async {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("An error has occured"),
          content: Text(text),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK")),
          ],
        );
      });
}

void showSuccessDialog({required BuildContext context, String? text}) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            alignment: Alignment.center,
            child: SizedBox(
                height: 100.0,
                width: 80.0,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    Text(
                      text ?? "Success",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ))));
      });
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Log out"))
          ],
        );
      }).then((value) => value ?? false);
}
