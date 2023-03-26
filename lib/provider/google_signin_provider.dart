import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as dev;

class GoogleSignInProvider extends ChangeNotifier{
  final _googleSignIn = GoogleSignIn();
  //variable to get the data of the signed in user
  GoogleSignInAccount? _user;
  //Create a getter
  GoogleSignInAccount get user => _user!;

  //Method that is executed when the user clicks on the sign in with Google btn
  Future<bool> googleLogin() async{
    bool loggedIn = false;
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
        loggedIn = true;
      }
    }catch (error){
      dev.log(error.toString());
    }
    return loggedIn;
    notifyListeners();

  }

  Future signInWithEmailAndPassword(String email,String password) async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );
    notifyListeners();
  }

  Future createUserWithEmailAndPassword(String email,String password) async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
    notifyListeners();
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

  /// Logout the user
  Future googleLogout() async{
    await _googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}