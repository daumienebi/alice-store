import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData iconData;
  final Function()? onPressed;
  const CustomButton({Key? key,required this.iconData,this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? (){},
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Icon(iconData,color: Colors.black,),
      ),
    );
  }
}
