import 'package:alice_store/provider/firebase_auth_provider.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/ui/widgets/my_text_field.dart';
import 'package:alice_store/utils/dialogs.dart';
import 'package:alice_store/utils/navigator_util.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController confirmPasswordController = TextEditingController();


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
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          //Lock icon
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: SizedBox(
              height: 150,
              width: 100,
              child: Icon(
                Icons.lock,
                size: 120,
                color: Colors.blueGrey,
              ),
            ),
          ),
          //Welcome text
          const Text(
            'Hello there !',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 20),
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
                      bool emailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
                      if(!emailValid){
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
                      if(value.length < 7){
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
                      if(value.length < 7){
                        return 'The password must contain at least 7 characters';
                      }
                      if(!passwordConfirmed()){
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
                        //Close this screen first so that the user can't return
                        Navigator.of(context).pop();
                        Navigator.of(context).push(NavigatorUtil.createRouteWithFadeAnimation(
                            newPage: const SignInPage()));
                      },
                      style: TextButton.styleFrom(backgroundColor: Colors.greenAccent),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.black54
                        ),
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
      padding: const EdgeInsets.only(top: 30,left: 20,right: 20),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            if(_formKey.currentState!.validate()){
              createUserWithEmailAndPassword();
            }
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
    FirebaseAuthProvider provider = Provider.of<FirebaseAuthProvider>(context, listen: false);
    return InkWell(
      onTap: () async{
        await provider.googleLogin();
        //NavigatorUtil.createRouteWithFadeAnimation(newPage: MainPage());
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

  Future createUserWithEmailAndPassword() async{
    bool userCreated;
    _email = emailController.text.trim();
    _password = passwordController.text.trim();
    _confirmPassword = confirmPasswordController.text.trim();
    if(passwordConfirmed()){
      userCreated = await Provider.of<FirebaseAuthProvider>(context,listen: false)
          .createUserWithEmailAndPassword(_email, _password);
      if(userCreated){
        //Close this page before going to the main page
        Navigator.of(context).pop();
        Navigator.of(context).push(NavigatorUtil.createRouteWithSlideAnimation(
          newPage: const MainPage())
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Welcome, your account was created successfully')
        ));
      }else{
        Dialogs.showMessage(
            context: context,
            messageIcon: const Icon(Icons.cancel,color: Colors.red),
            title: 'Error :(',
            message: 'Unable to create your account, check your email/password and your internet connection'
        );
      }
    }
  }

  /// Checks if the two passwords match
  bool passwordConfirmed(){
    if(passwordController.text.trim() == confirmPasswordController.text.trim()){
      return true;
    }else{
      return false;
    }
  }
}
