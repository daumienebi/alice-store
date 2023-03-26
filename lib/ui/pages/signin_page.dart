import 'package:alice_store/provider/google_signin_provider.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/ui/widgets/my_text_field.dart';
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.90,
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
                              return 'Email error';
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
                            if(value.length < 7){
                              return 'La contraseña debe contener 7 caracteres como minimo';
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
                              Navigator.of(context).push(NavigatorUtil.createRouteWithSlideAnimation(
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
          onPressed: () async{
            if(_formKey.currentState!.validate()){
              await signInWithEmailAdnPassword();
            }
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
          Navigator.of(context).push(NavigatorUtil.createRouteWithSlideAnimation(
              newPage: const MainPage())
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Error iniciando sesión con Google')));
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

  Future signInWithEmailAdnPassword() async{
    _email = emailController.text.trim();
    _password = passwordController.text.trim();
    await Provider.of<GoogleSignInProvider>(context,listen: false)
        .signInWithEmailAndPassword(_email, _password);
  }
}
