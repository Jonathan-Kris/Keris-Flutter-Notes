import 'package:flutter/material.dart';

void showErrorDialog({required BuildContext context, String? text}) {
    showDialog(context: context, builder:(context) {
      return Dialog(
        alignment: Alignment.center, 
        child: SizedBox(height: 100.0,
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
              )))
        );
      });
}

void showSuccessDialog({required BuildContext context, String? text}) {
    showDialog(context: context, builder:(context) {
      return Dialog(
        alignment: Alignment.center, 
        child: SizedBox(height: 100.0,
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
              )))
        );
      });
}
