import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier{
  User? _currentUser;

  // check if the user is authenticated
  bool get userIsAuthenticated => _currentUser != null;

  // obtain the current user
  User? get currentUser => _currentUser;

  // listen to the auth changes to obtain the state of the user
  void listenToAuthChanges(){
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUser = user;
    });
    notifyListeners();
  }
}
/*
class AuthState extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  set isAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }
}
* */