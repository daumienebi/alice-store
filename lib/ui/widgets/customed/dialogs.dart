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
}