import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier{
  User? _currentUser;

  //check if the user is authenticated
  bool get userIsAuthenticated => _currentUser != null;

  // listen to the auth changes to obtain the state of the user
  void listenToAuthChanges(){
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUser = user;
    });
    notifyListeners();
  }
}