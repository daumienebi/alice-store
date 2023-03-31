import 'package:alice_store/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../pages/pages.dart';

class NotSignedInUserDrawer extends StatelessWidget {
  const NotSignedInUserDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return drawerContents(context);
  }

  /// The drawer that is returned when a user is not signed in
  Widget drawerContents(BuildContext context){
    return Container(
      color: Colors.cyan[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            'assets/lottie_animations/auth.json',
            repeat: false,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: RichText(text: TextSpan(
                style: TextStyle(color: Colors.black87),
                children: [
                  TextSpan(text:'Sign In',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.lightBlue)),
                  TextSpan(text: ' for a better experience')
                ]
            )),
          ),
          TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.black87,fixedSize: Size(150,50)),
              onPressed: (){
                Navigator.of(context).push(NavigatorUtil.createRouteWithFadeAnimation(newPage: SignInPage()));
              },
              child: Text('Sign In',style: TextStyle(color: Colors.white),)
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: RichText(text: TextSpan(
                style: TextStyle(color: Colors.black87),
                children: [
                  TextSpan(text:'Or'),
                  TextSpan(text:' Sign Up',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.lightBlue)),
                  TextSpan(text: ' if you don\'t have an account')
                ]
            )),
          ),
          TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.greenAccent,fixedSize: Size(150,50)),
              onPressed: (){
                Navigator.of(context).push(NavigatorUtil.createRouteWithFadeAnimation(newPage: SignUpPage()));
              },
              child: Text('Sign Up',style: TextStyle(color: Colors.black87),)
          ),
        ],
      ),
    );
  }
}
