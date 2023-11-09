import 'package:flutter/material.dart';
// import '../authentication/register.dart';

class EnterButton extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;

  const EnterButton({
    Key? key,
    required this.name,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          // backgroundColor: Colors.amber,
          backgroundColor: Colors.yellow[800],
          padding:
              const EdgeInsets.symmetric(horizontal: 100.0, vertical: 12.0)),
      child: Text(
        name,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16.0),
      ),
    );
  }
}