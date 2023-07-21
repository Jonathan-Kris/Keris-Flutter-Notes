import 'package:flutternotes/services/auth/auth_exceptions.dart';
import 'package:flutternotes/services/auth/auth_provider.dart';
import 'package:flutternotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test("Should not be initialize to begin with", () {
      expect(provider.isInitialize, false);
    });

    test("Can't logout if not initialized", () {
      expect(provider.logout(),
          throwsA(const TypeMatcher<NotInitializeException>()));
    });

    test("Can't create User if not initialized", () {
      expect(provider.createUser(email: "test@email.com", password: "password"),
          throwsA(const TypeMatcher<NotInitializeException>()));
    });

    test("Should be able to initialize", () async {
      await provider.initialize();
      expect(provider.isInitialize, true);
    });

    test("Shouldn't be able to create user with weak email", () async {});

    test("Shouldn't be able to create user with weak password", () async {});
  });
}

class NotInitializeException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialize = false;
  bool get isInitialize => _isInitialize;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialize = true;
  }

  @override
  Future<AuthUser?> createUser(
      {required String email, required String password}) async {
    if (!isInitialize) throw NotInitializeException();
    Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser?> login({required String email, required String password}) {
    if (!isInitialize) throw NotInitializeException();
    if (email == "foo.bar@gmail.com") throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialize) throw NotInitializeException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailNotification() async {
    if (!isInitialize) throw NotInitializeException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();

    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
