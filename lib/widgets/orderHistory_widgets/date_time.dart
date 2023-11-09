import 'package:flutter/material.dart';

class DateTimeTextStyle extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;

  const DateTimeTextStyle(
      {super.key, required this.text, required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.028,
          fontWeight: fontWeight,
          color: Colors.black54),
    );
  }
}