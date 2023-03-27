import 'package:alice_store/provider/google_signin_provider.dart';
import 'package:alice_store/ui/widgets/my_text_field.dart';
import 'package:alice_store/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('A L I C E S T O R E'),
        centerTitle: true,
        backgroundColor: Colors.cyan[100],
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Introduce su correo aqui y le enviaremos un codigo verifiación.',
              style: TextStyle(
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            MyTextField(
                obscureText: false,
                hintText: 'Introduce el correo',
                labelText: 'Email',
                controller: emailController,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Debe introducir un correo válido';
                  }
                  if('' == '') {
                    //add the pattern to match an email
                    return ' ';
                  }
                  return '';
                },
                icon: const Icon(Icons.email_outlined),
            ),
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.greenAccent
              ),
                onPressed: resetPassword,
                child: const Text(
                    'Enviar código',
                    style: TextStyle(
                    color: Colors.black87
                ))
            )
          ],
        ),
      ),
    );
  }


  /// Reset a the password
  Future resetPassword() async{
    bool verificationSent;
    verificationSent = await Provider.of<GoogleSignInProvider>(context,listen: false)
        .resetPassword(emailController.text.trim());
    if(verificationSent){
      Dialogs.messageDialog(
        context: context,
        messageIcon: const Icon(Icons.check_circle_outline,color: Colors.green),
        title: 'Enviado !',
        message: 'El enlace para restablecer su contraseña fue enviado '
            'corectamente, revise su correo.'
      );
    }else{
      Dialogs.messageDialog(
          context:context,
          messageIcon: const Icon(Icons.cancel,color: Colors.red),
          title: 'Error',
          message: 'No se pudo enviar el código de verificacion, asegurese de '
              'haber introducido un correo válido'
      );
    }
  }
}
