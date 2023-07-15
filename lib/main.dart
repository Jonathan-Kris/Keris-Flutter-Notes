import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/views/home_page.dart';
import 'package:flutternotes/views/login_view.dart';
import 'package:flutternotes/views/notes_view.dart';
import 'package:flutternotes/views/register_view.dart';
import 'package:flutternotes/views/verify_email_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keris Project Flutter Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        "/home" : (context) => const HomePage(),
        "/login" :(context) => const LoginView(),
        "/register" :(context) => const RegisterView(),
        "/verify-email" : (context) => const VerifyEmailView(),
        "/notes" : (context) => const NotesView()
      },
    );
  }
}