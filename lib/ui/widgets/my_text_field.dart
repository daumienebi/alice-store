import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final bool obscureText;
  final String hintText;
  final String labelText;
  final Icon icon;
  final String Function(String?)? validator;
  final TextEditingController controller;

  const MyTextField({
    Key? key,
    required this.obscureText,
    required this.hintText,
    required this.labelText,
    required this.controller,
    required this.icon,
    this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.words,
          cursorColor: Colors.black,
          obscureText: obscureText,
          decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26)
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              labelText: labelText,
              labelStyle: const TextStyle(
                  color: Colors.black87, fontSize: 17),
              hintText: hintText,
              suffixIcon: icon,
              suffixIconColor: Colors.white
          ),
          //The validator function returns a String? and receives a String?
          validator: validator
      )
    );
  }
}