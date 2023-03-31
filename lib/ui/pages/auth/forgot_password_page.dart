import 'package:alice_store/provider/firebase_auth_provider.dart';
import 'package:alice_store/ui/widgets/customed/my_text_field.dart';
import 'package:alice_store/ui/widgets/customed/dialogs.dart';
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
                'Type in your email address below and a reset password link will be sent to you.',
              style: TextStyle(
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            MyTextField(
                obscureText: false,
                hintText: 'Enter email',
                labelText: 'Email',
                controller: emailController,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'You must input a valid email address';
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
                    'Send link',
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
    verificationSent = await Provider.of<FirebaseAuthProvider>(context,listen: false)
        .resetPassword(emailController.text.trim());
    if(verificationSent){
      Dialogs.showMessage(
        context: context,
        messageIcon: const Icon(Icons.check_circle_outline,color: Colors.green),
        title: 'Link sent !',
        message: 'The link to reset your password has been sent, please check your email.'
      );
    }else{
      Dialogs.showMessage(
          context:context,
          messageIcon: const Icon(Icons.cancel,color: Colors.red),
          title: 'Error',
          message: 'The reset password link could not be sent, please make sure you introduced a valid email address'
      );
    }
  }
}
