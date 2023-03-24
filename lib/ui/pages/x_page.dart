import 'package:alice_store/ui/pages/home_page.dart';
import 'package:alice_store/ui/pages/login_page.dart';
import 'package:alice_store/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

//This page wil be restructured later on
class XPage extends StatelessWidget {
  const XPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return const HomePage();
          }else if (snapshot.hasError){
            return const Center(child: Text('Error'));
          }else{
            return const LoginPage();
          }
        },
      ),
    );
  }
}
