import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

// This main page to determine the main screen that will displayed to the user
// depending on the auth state
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a stream builder to listen to the user sign_in/sign_out activities
      // and return a page depending on the results
      body: StreamBuilder<User?>(
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
            return const Center(child: Text('Error signing in'));
          }
          return const SignInPage();
        },
      ),
    );
  }
}
