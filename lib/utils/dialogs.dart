import 'package:flutter/material.dart';

/// Class for some custom message dialogs to be used throughout the app
class Dialogs{
   static Future messageDialog({Icon? messageIcon,required BuildContext context,
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
}