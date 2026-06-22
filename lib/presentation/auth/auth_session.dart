import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  const AuthUser({required this.name, required this.email});
  final String name;
  final String email;
}

class AuthSession {
  AuthSession._();
  static final AuthSession instance = AuthSession._();

  AuthUser? _user;

  AuthUser? get user => _user;
  bool get isLoggedIn => _user != null;

  void signIn({required String name, required String email}) {
    _user = AuthUser(name: name, email: email);
  }

  void signOut() {
    _user = null;
  }
}
