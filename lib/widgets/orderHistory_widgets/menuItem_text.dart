import 'package:flutter/material.dart';

class MenuItemText extends StatelessWidget {
  final String text;

  const MenuItemText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
        fontSize: MediaQuery
            .of(context)
            .size
            .width *
            0.035,
      ),
    );
  }
}