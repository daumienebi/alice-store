import 'package:alice_store/provider/firebase_auth_provider.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/ui/widgets/my_text_field.dart';
import 'package:alice_store/utils/dialogs.dart';
import 'package:alice_store/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
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
                'Enter your password to confirm your account deletion',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: MyTextField(
                  obscureText: true,
                  hintText: 'Enter password',
                  labelText: 'Password',
                  controller: passwordController,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'You must introduce a password';
                    }
                    return '';
                  },
                  icon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.greenAccent
              ),
                onPressed: (){
                  _formKey.currentState!.validate();
                  deleteAccount();
                },
                child: const Text(
                    'Confirm',
                    style: TextStyle(
                    color: Colors.black87
                ))
            )
          ],
        ),
      ),
    );
  }


  /// Delete the user's account
  Future deleteAccount() async{
    bool accountDeleted = false;
    accountDeleted = await Provider.of<FirebaseAuthProvider>(context,listen: false)
        .deleteUserAccount(password : passwordController.text.trim());

    // messages
    if(accountDeleted){
      Dialogs.showMessage(
        context: context,
        messageIcon: const Icon(Icons.check_circle_outline,color: Colors.green),
        title: 'Account deleted !',
        message: 'Your accout has been deleted successfully.'
      );
      // navigate back to the main page
      Navigator.of(context).push(NavigatorUtil.createRouteWithFadeAnimation(newPage: const MainPage()));
    }else{
      Dialogs.showMessage(
          context:context,
          messageIcon: const Icon(Icons.cancel,color: Colors.red),
          title: 'Error',
          message: 'Error deleting your account, please try again later'
      );
    }
  }
}
