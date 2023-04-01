import 'package:alice_store/provider/firebase_auth_provider.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/ui/components/customed/my_text_field.dart';
import 'package:alice_store/ui/components/customed/dialogs.dart';
import 'package:alice_store/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email = "";
  String _password = "";
  String _confirmPassword = "";

  // form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start, children: [
          //Lock animation
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
          //SignIn text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black87, fontSize: 20,fontWeight: FontWeight.bold),
                ),
                const Text(
                  'for a better experience',
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
                    icon: Icon(
                      Icons.email_outlined,
                      color: Colors.black45,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'You must input a valid email address';
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
                    icon: Icon(
                      Icons.password_outlined,
                      color: Colors.black45,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'You must introduce a password';
                      }
                      if (value.length < 7) {
                        return 'The password must contain at least 7 characters';
                      }
                      return '';
                    },
                  ),
                  const SizedBox(height: 15),
                  //Password field
                  MyTextField(
                    obscureText: true,
                    hintText: 'Confirm password',
                    labelText: 'Confirm Password',
                    controller: confirmPasswordController,
                    icon: Icon(
                      Icons.password_outlined,
                      color: Colors.black45,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'You must introduce a password';
                      }
                      if (value.length < 7) {
                        return 'The password must contain at least 7 characters';
                      }
                      if (!passwordConfirmed()) {
                        return 'The two passwords must match';
                      }
                      return '';
                    },
                  ),
                ],
              ),
            ),
          ),

          signUpButton(),
          const SizedBox(height: 15),
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
                googleSignInButton(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a member ? '),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            NavigatorUtil.createRouteWithFadeAnimation(
                                newPage: const SignInPage()));
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.greenAccent),
                      child: const Text(
                        'Log In',
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget signUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            // the form validation is not working correctly
            //if (_formKey.currentState!.validate()) {
              //createUserWithEmailAndPassword();
            //}
            _formKey.currentState!.validate();
            createUserWithEmailAndPassword();
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.black87, fixedSize: const Size(50, 60)),
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget googleSignInButton() {
    FirebaseAuthProvider provider =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    return InkWell(
      onTap: () async {
        await provider.googleLogin();
        Navigator.of(context).pushReplacement(
            NavigatorUtil.createRouteWithSlideAnimation(
                newPage: const MainPage()));
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

  Future createUserWithEmailAndPassword() async {
    bool userCreated;
    _email = emailController.text.trim();
    _password = passwordController.text.trim();
    _confirmPassword = confirmPasswordController.text.trim();
    if (passwordConfirmed()) {
      userCreated =
          await Provider.of<FirebaseAuthProvider>(context, listen: false)
              .createUserWithEmailAndPassword(_email, _password);
      if (userCreated) {
        Navigator.of(context).pushReplacement(NavigatorUtil.createRouteWithSlideAnimation(
            newPage: const MainPage()));
        Dialogs.showIcon(
            context: context,
            messageIcon: Icon(Icons.check_circle,color: Colors.green),
            title: ' Account created!',
            content: LottieBuilder.asset(
              'assets/lottie_animations/check.json',
              repeat: true,
            )
        );
      } else {
        Dialogs.showMessage(
            context: context,
            messageIcon: const Icon(Icons.cancel, color: Colors.red),
            title: 'Error :(',
            message:
                'Unable to create your account, check your email/password and your internet connection');
      }
    }
  }

  /// Checks if the two passwords match
  bool passwordConfirmed() {
    if (passwordController.text.trim() ==
        confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }
}
