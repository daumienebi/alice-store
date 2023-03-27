import 'package:alice_store/provider/google_signin_provider.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/ui/widgets/my_text_field.dart';
import 'package:alice_store/utils/dialogs.dart';
import 'package:alice_store/utils/navigator_util.dart';
import 'package:flutter/material.dart';
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
    //emailController.dispose();
    //passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 1.00,
              width: double.infinity,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                //Skip text
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        //Close this screen first so that the user can't return
                        Navigator.of(context).pop();
                        Navigator.of(context).push(NavigatorUtil.createRouteWithFadeAnimation(
                            newPage: HomePage()));
                      },
                      style: TextButton.styleFrom(backgroundColor: Colors.white),
                      child: const Text(
                        'Continuar sin iniciar sesión',
                        style: TextStyle(
                            color: Colors.black87,),
                      ),
                    ),
                  ],
                ),
                //Lock icon
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                    height: 200,
                    width: 100,
                    child: Icon(
                      Icons.lock,
                      size: 100,
                      color: Colors.black87,
                    ),
                  ),
                ),
                //Welcome text
                const Text(
                  '¡Bienvenido te hemos echado de menos!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
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
                            color: Colors.black87,
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Debe introducir un correo válido';
                            }
                            bool emailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
                            if(!emailValid){
                              return 'Por favor, introduce un correo válido';
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
                            color: Colors.black87,
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Debe introducir una contraseña';
                            }
                            return '';
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(NavigatorUtil.createRouteWithFadeAnimation(
                                    newPage: const ForgotPasswordPage()));
                              },
                              child: const Text(
                                'Olvidaste la contraseña ?',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
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
                        'O continua con',
                        style: TextStyle(color: Colors.black54),
                      ),
                      //Google sign in button
                      googleSignInButton(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No tienes cuenta ? '),
                          TextButton(
                            onPressed: () {
                              //Close this screen first so that the user can't return
                              Navigator.of(context).pop();
                              Navigator.of(context).push(NavigatorUtil.createRouteWithFadeAnimation(
                                  newPage: const SignUpPage()));
                            },
                            style: TextButton.styleFrom(backgroundColor: Colors.greenAccent),
                            child: const Text(
                              'Registrate',
                              style: TextStyle(
                                color: Colors.black54,),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ])),
        ),
      ),
    );
  }

  Widget signInButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            // was trying to check if the form is validated before signing in
            // but its not working
            //if(_formKey.currentState!.validate()){
            //  await signInWithEmailAndPassword();
            //}
            signInWithEmailAndPassword();
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.black87, fixedSize: const Size(50, 60)),
          child: const Text(
            'Iniciar sesión',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget googleSignInButton(context) {
    GoogleSignInProvider provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    return InkWell(
      onTap: () async{
        bool loggedIn = await provider.googleLogin();
        if(loggedIn){
          //If the user is logged in, navigate to the MainPage, for some reason
          // it's not going to the page automatically
          Navigator.of(context).push(NavigatorUtil.createRouteWithSlideAnimation(
              newPage: const MainPage())
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 7),
              content: Text('Error iniciando sesión con Google, revise su conexión a internet')));
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

  Future signInWithEmailAndPassword() async{
    GoogleSignInProvider provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    bool signedIn;
    _email = emailController.text.trim();
    _password = passwordController.text.trim();
    signedIn = await provider.signInWithEmailAndPassword(_email, _password);
    if(signedIn){
      // if the user is signed in, the MainPage StreamBuilder handles the
      // page that will be shown, no need to explicitly call the MainPage
      //Navigator.of(context).push(NavigatorUtil.createRouteWithSlideAnimation(
          //newPage: const MainPage())
      //);
    }else{
      Dialogs.messageDialog(
          context: context,
          messageIcon: const Icon(Icons.cancel,color: Colors.red),
          title: 'Error !',
          message: 'No se ha podido iniciar sesión, revise su correo/contraseña y '
              'su conexión a internet'
      );
    }
  }
}
