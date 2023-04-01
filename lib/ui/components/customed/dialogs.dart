import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/utils/navigator_util.dart';
import 'package:flutter/material.dart';

/// Class for some custom message dialogs to be used throughout the app
class Dialogs{
   static Future showMessage({Icon? messageIcon,required BuildContext context,
   required String title,required String message}){
     return showDialog(
       context: context,
       builder: (context) {
         return AlertDialog(
           title: Row(
             children: [
               messageIcon ?? const Icon(Icons.info_outline),
               Text(title)
             ],
           ),
           content: Text(message),
         );
       },
     );
   }

   /// Show a dialog with  a body for Animation of any other widget
   static Future showIcon({Icon? messageIcon,required BuildContext context,
     required String title,required Widget content}){
     return showDialog(
       context: context,
       builder: (context) {
         return AlertDialog(
           title: Row(
             children: [
               messageIcon ?? const Icon(Icons.info_outline),
               Text(title)
             ],
           ),
           content: content,
         );
       },
     );
   }

   /// Shows a dialog to confirm if the user wants to carry-out the action
   /// Returne 1 if the user clicks 'Yes' and 0 for 'No'
  static Future<int> confirmAction({required BuildContext context,required String actionTitle,
    required String content}) async {
    int returnValue = 0;
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(actionTitle),
              content:
                  Text(content),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(
                          context, 'Return value'); //Return value to the caller
                    },
                    child: Text(
                      'No',
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                    onPressed: () {
                      returnValue = 1;
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Colors.green),
                    ))
              ],
            ));
    return Future.value(returnValue);
  }

  static Future authPrompt(BuildContext context) {
     return showDialog(
       context: context,
       builder: (context) {
         return AlertDialog(
           title: Row(
             children: [
               Icon(Icons.login,color: Colors.green),
               Text(' Sign in')
             ],
           ),
           content: Text('You must be registered to carry out that action. Sign '
               'in if you already have an account or Sign up and create your account in few seconds'),
           actions: [
             TextButton(
                 onPressed: (){
                   Navigator.of(context).pop();
                   Navigator.of(context).pop();
                   Navigator.of(context).push(NavigatorUtil.createRouteWithSlideAnimation(newPage: SignInPage()));
                 },
                 child: Text('Sign In',style: TextStyle(color: Colors.black87),),
               style: TextButton.styleFrom(backgroundColor: Colors.lightGreenAccent),
             ),
             TextButton(
                 onPressed: (){
                   // call the pop() method to close the dialog, calling it
                   // twice will close the dialog and the actual shopping page
                   Navigator.of(context).pop();
                   Navigator.of(context).pop();
                   Navigator.of(context).push(NavigatorUtil.createRouteWithSlideAnimation(newPage: SignUpPage()));
                 },
                 child: Text('Sign Up',style: TextStyle(color: Colors.white),),
                 style: TextButton.styleFrom(backgroundColor: Colors.black87)
             )
           ],
         );
       },
     );
  }
}