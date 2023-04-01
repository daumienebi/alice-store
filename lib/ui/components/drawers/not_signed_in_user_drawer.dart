import 'package:alice_store/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../pages/pages.dart';

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
          // use an expanded so that the button and animations covers the
          // available space
          Expanded(child: authWidget(context)),
          // display app version
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 15),
            child: FutureBuilder(
                future: getVersion(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Version: ${snapshot.data.toString()}',
                      style: const TextStyle(
                          fontSize: 16, color: Colors.black38),
                    );
                  } else {
                    return const Text("");
                  }
                }),
          )
        ],
      ),
    );
  }

  /// Sign in and sign up buttons for auth
  Widget authWidget(BuildContext context){
    return Column(
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
              Navigator.of(context).pop();
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
              Navigator.of(context).pop();
              Navigator.of(context).push(NavigatorUtil.createRouteWithFadeAnimation(newPage: SignUpPage()));
            },
            child: Text('Sign Up',style: TextStyle(color: Colors.black87),)
        ),
      ],
    );
  }

  Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return Future.value(version);
  }
}
