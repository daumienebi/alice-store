import 'package:alice_store/ui/pages/home_page.dart';
import 'package:alice_store/ui/pages/signin_page.dart';
import 'package:alice_store/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

// This main page to determine the main screen that will displayed to the user
// depending on the auth state
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a stream builder to listen to the user signin/signout activities and
      // return a page depending on the results
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulseRise,
                  colors: Constants.loadingIndicatorColors,
                )
            );
          }else if (snapshot.hasData){
            return HomePage();
          }else if (snapshot.hasError){
            return const Center(child: Text('Error'));
          }
          return const SignInPage();
        },
      ),
    );
  }
}
