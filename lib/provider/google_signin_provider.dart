import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as dev;

class GoogleSignInProvider extends ChangeNotifier{
  final _googleSignIn = GoogleSignIn();
  //variable to get the data of the signed in user (the google account)
  GoogleSignInAccount? _user;
  //variable for the users that sign in with email and password
  User? _emailPasswordUser;

  //Create the getters
  GoogleSignInAccount get user => _user!;
  User get emailPasswordUser => _emailPasswordUser!;

  //Method that is executed when the user clicks on the sign in with Google btn
  Future<bool> googleLogin() async{
    bool signedIn = false;
    try{
      final googleUser = await _googleSignIn.signIn();
      //make sure the user selected an account
      if(googleUser != null){
        _user = googleUser;
        //get the authentication
        final googleAuth = await googleUser.authentication;
        //Obtain the credentials that will be used to sign in to Firebase
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        signedIn = true;
      }
    }catch (error){
      dev.log(error.toString());
    }
    notifyListeners();
    return signedIn;
  }

  /// Sign in an existing user with their email and password
  Future<bool> signInWithEmailAndPassword(String email,String password) async{
    bool signedIn = false;
    dev.log('Entering to sign in with email and pass');
    try{
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email,password: password);
      if(userCredential.user != null){
        _emailPasswordUser = userCredential.user;
        signedIn = true;
      }
    } on FirebaseAuthException catch(error){
      dev.log(error.toString());
    }
    notifyListeners();
    return Future.value(signedIn);
  }

  /// Returns true if the user was created and false if the user was not created
  Future<bool> createUserWithEmailAndPassword(String email,String password) async{
    bool userCreated = false;
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      userCreated = true;
      notifyListeners();
    } on FirebaseAuthException catch(error){
      dev.log(error.toString());
    }
    return Future.value(userCreated);
  }

  /// Returns true if the verification code was sent to the user and false
  /// if it wasn't
  Future<bool>resetPassword(String email) async{
    bool verificationSent = false;
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      verificationSent = true;
    } on FirebaseAuthException catch(error){
      dev.log(error.toString());
    }
    notifyListeners();
    return verificationSent;
  }

  /// Logout the user by checking if the user signed in using the Google signIn
  /// method o with a regular email and password
  Future googleLogout() async{
    if(await _googleSignIn.isSignedIn()){
      await _googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
    }else {
      await FirebaseAuth.instance.signOut();
    }
    notifyListeners();
  }
}