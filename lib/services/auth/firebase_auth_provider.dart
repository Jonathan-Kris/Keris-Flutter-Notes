import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutternotes/firebase_options.dart';
import 'package:flutternotes/services/auth/auth_provider.dart';
import 'package:flutternotes/services/auth/auth_user.dart';
import 'package:flutternotes/services/auth/auth_exceptions.dart';
import 'dart:developer' as devtools show log;

class FirebaseAuthProvider extends AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser?> createUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotAbleToBeRegisteredException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        throw WeakPasswordAuthException();
      } else if (e.code == "email-already-in-use") {
        throw EmailAlreadyInUsedAuthException();
      } else if (e.code == "invalid-email") {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    devtools.log(user.toString());
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser?> login(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw UserNotFoundAuthException();
      } else if (e.code == "wrong-password") {
        throw WrongPasswordAuthException();
      } else if (e.code == "too-many-requests") {
        throw TooManyRequestAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        await FirebaseAuth.instance.signOut();
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on Exception catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailNotification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
