import 'package:flutter/material.dart';
import 'package:flutternotes/constants/routes.dart';
import 'package:flutternotes/enums/menu_action.dart';
import 'package:flutternotes/helpers/colors.dart';
import 'package:flutternotes/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

import 'package:flutternotes/widgets/custom_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  MenuAction? selectedAction;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
          backgroundColor: CustomColorPalette.appBarBackgroundColor,
          actions: [
            PopupMenuButton<MenuAction>(
              initialValue: selectedAction,
              // Callback that sets the selected popup menu item.
              onSelected: (MenuAction item) async {
                devtools.log(item.toString());
                if (item.name == "logout") {
                  final flagLogout = await showLogoutDialog(context);

                  // If user choose to logout, process to Firebase
                  if (flagLogout) {
                    AuthService.firebase().logout();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        homeRoute,
                        (route) => false,
                      );
                    }
                  }
                }

                setState(() {
                  selectedAction = item;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<MenuAction>>[
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.itemTwo,
                  child: Text('Item Two'),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.itemThree,
                  child: Text('Item Three'),
                ),
              ],
            ),
          ],
        ),
        body: const Center(
            child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(children: [Text("Main view is here")]),
        )));
  }
}
