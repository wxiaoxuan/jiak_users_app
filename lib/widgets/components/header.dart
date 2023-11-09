import 'package:flutter/material.dart';

class HeaderTextStyle extends StatelessWidget {
  final String text;

  const HeaderTextStyle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.040,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}