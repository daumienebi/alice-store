import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as dev;

class FirebaseAuthProvider extends ChangeNotifier {
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;

  final _googleSignIn = GoogleSignIn();
  //variable to get the data of the signed in user (the google account)
  GoogleSignInAccount? _user;
  //variable for the users that sign in with email and password
  User? _emailPasswordUser;

  //Create the getters
  GoogleSignInAccount get user => _user!;
  User get emailPasswordUser => _emailPasswordUser!;

  //Method that is executed when the user clicks on the sign in with Google btn
  Future<bool> googleLogin() async {
    bool signedIn = false;
    try {
      final googleUser = await _googleSignIn.signIn();
      //make sure the user selected an account
      if (googleUser != null) {
        _user = googleUser;
        //get the authentication
        final googleAuth = await googleUser.authentication;
        //Obtain the credentials that will be used to sign in to Firebase
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        await FirebaseAuth.instance.signInWithCredential(credential);
        signedIn = true;
      }
    } catch (error) {
      dev.log(error.toString());
    }
    notifyListeners();
    return signedIn;
  }

  /// Sign in an existing user with their email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    bool signedIn = false;
    dev.log('Entering to sign in with email and pass');
    try {
      final userCredential = await _fbAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        _emailPasswordUser = userCredential.user;
        signedIn = true;
      }
    } on FirebaseAuthException catch (error) {
      dev.log(error.toString());
    }
    notifyListeners();
    return Future.value(signedIn);
  }

  /// Returns true if the user was created and false if the user was not created
  Future<bool> createUserWithEmailAndPassword(
      String email, String password) async {
    bool userCreated = false;
    try {
      await _fbAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      userCreated = true;
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      dev.log(error.toString());
    }
    return Future.value(userCreated);
  }

  /// Returns true if the verification code was sent to the user and false
  /// if it wasn't
  Future<bool> resetPassword(String email) async {
    bool verificationSent = false;
    try {
      await _fbAuth.sendPasswordResetEmail(email: email);
      verificationSent = true;
    } on FirebaseAuthException catch (error) {
      dev.log(error.toString());
    }
    notifyListeners();
    return verificationSent;
  }

  /// Logout the user by checking if the user signed in using the Google signIn
  /// method o with a regular email and password
  Future logout() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.disconnect();
      await _fbAuth.signOut();
    } else {
      await _fbAuth.signOut();
    }
    notifyListeners();
  }

  /// Delete the current users account. Require the users password to reauthenticate
  /// and delete the account
  Future deleteUserAccount({String? password}) async {
    // this method is currently called from the profile page which is only displayed
    // to authenticated users. Modify for future use if that changes
    bool accountDeleted = false;
    try {
      User currentUser = _fbAuth.currentUser!;
      
      //delete google signed in user
      if (await _googleSignIn.isSignedIn()) {
        //refresh the users token incase it expired
        await currentUser.reload();
        AuthCredential credentials = GoogleAuthProvider.credential(
          //forceRefresh = true to make the token to be refreshed
          idToken: await currentUser.getIdToken(true),
        );
        await currentUser.reauthenticateWithCredential(credentials);
        await currentUser.delete();
        accountDeleted = true;
      } else {
        // case users who signed in with email and password
        AuthCredential credentials = EmailAuthProvider.credential(
            email: currentUser.email!, password: password!);
        // re-authenticate the user because the delete() method requires the user to have recently signed in
        await currentUser.reauthenticateWithCredential(credentials);
        await currentUser.delete();
        accountDeleted = true;
      }
    } on FirebaseAuthException catch (error) {
      dev.log(error.toString());
    }
    notifyListeners();
    return accountDeleted;
  }
}
