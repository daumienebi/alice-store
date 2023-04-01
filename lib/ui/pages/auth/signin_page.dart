import 'package:alice_store/provider/firebase_auth_provider.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/ui/components/customed/my_text_field.dart';
import 'package:alice_store/ui/components/customed/dialogs.dart';
import 'package:alice_store/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _email = "";
  String _password = "";

  // form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            //Skip text
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: () {
                      //Close this screen first so that the user can't return
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          NavigatorUtil.createRouteWithFadeAnimation(
                              newPage: HomePage()));
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text(
                      'Continue as guest',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //Lock icon
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: LottieBuilder.asset(
                  'assets/lottie_animations/auth.json',
                  height: MediaQuery.of(context).size.height * 0.30,
                  repeat: false,
                ),
              ),
            ),
            //Log in text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign In',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black87, fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'welcome back!, we missed you',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    //Email field
                    MyTextField(
                      obscureText: false,
                      hintText: 'Introduce email',
                      labelText: 'Email',
                      controller: emailController,
                      icon: const Icon(
                        Icons.email_outlined,
                        color: Colors.black45,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'You must introduce a valid email address';
                        }
                        bool emailValid =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value);
                        if (!emailValid) {
                          return 'Please, introduce a valid email address';
                        }
                        return '';
                      },
                    ),
                    const SizedBox(height: 15),
                    //Password field
                    MyTextField(
                      obscureText: true,
                      hintText: 'Introduce password',
                      labelText: 'Password',
                      controller: passwordController,
                      icon: const Icon(
                        Icons.password_outlined,
                        color: Colors.black45,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'You must introduce a password';
                        }
                        return '';
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  NavigatorUtil.createRouteWithFadeAnimation(
                                      newPage: const ForgotPasswordPage()));
                            },
                            child: const Text(
                              'Forgot password ?',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            signInButton(),
            const SizedBox(height: 10),
            //Google sign in + register button
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: [
                  const Text(
                    'Or continue with',
                    style: TextStyle(color: Colors.black54),
                  ),
                  //Google sign in button
                  googleSignInButton(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not a member yet ? '),
                      TextButton(
                        onPressed: () {
                          //Close this screen first so that the user can't return
                          //Navigator.of(context).pop();
                          Navigator.of(context).push(
                              NavigatorUtil.createRouteWithFadeAnimation(
                                  newPage: const SignUpPage()));
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.greenAccent),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget signInButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            // form state validation working correctly in the signup page
            // but not here
            //if(_formKey.currentState!.validate()){
            //print('Entering');
            //signInWithEmailAndPassword();
            //}
            _formKey.currentState!.validate();
            signInWithEmailAndPassword();
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.black87, fixedSize: const Size(50, 60)),
          child: const Text(
            'Sign In',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget googleSignInButton(context) {
    FirebaseAuthProvider provider =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    return InkWell(
      onTap: () async {
        bool loggedIn = await provider.googleLogin();
        if (loggedIn) {
          //If the user is logged in, navigate to the MainPage, for some reason
          // it's not going to the page automatically
          Navigator.of(context).pop();
          Navigator.of(context).push(
              NavigatorUtil.createRouteWithSlideAnimation(
                  newPage: const MainPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 7),
              content: Text(
                  'Error signing in with Google, please check your internet connection.')));
        }
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(15),
        child: Image.asset('assets/images/google.png', height: 40),
      ),
    );
  }

  Future signInWithEmailAndPassword() async {
    FirebaseAuthProvider provider =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    bool signedIn;
    _email = emailController.text.trim();
    _password = passwordController.text.trim();
    signedIn = await provider.signInWithEmailAndPassword(_email, _password);
    if (signedIn) {
      // if the user is signed in, the MainPage StreamBuilder handles the
      // page that will be shown, no need to explicitly call the MainPage
      Navigator.of(context).pop();
      Navigator.of(context).push(NavigatorUtil.createRouteWithSlideAnimation(
          newPage: MainPage()));
    } else {
      Dialogs.showMessage(
          context: context,
          messageIcon: const Icon(Icons.cancel, color: Colors.red),
          title: 'Error !',
          message:
              'Unable to sign in, please check email/password and your internet connection');
    }
  }
}
