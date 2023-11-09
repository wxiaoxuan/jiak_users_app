import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  late final TextEditingController controller;
  late final IconData icon;
  late final String hintText;
  bool isObscure = true; // hide the user input (used for pw)
  bool enabled = true; // if user is able to edit the field

  CustomTextField(
      {super.key,
      required this.controller,
      required this.icon,
      required this.hintText,
      required this.isObscure,
      required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white38,
          border: Border.all(
            color: Colors.black12,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(10.0),
        child: TextFormField(
          enabled: enabled,
          controller: controller,
          obscureText: isObscure,
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              icon,
              // color: const Color(0xfff5c43a),
              color: Colors.black87,
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}
