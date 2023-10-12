import 'package:flutter/material.dart';

class Headers extends StatelessWidget {
  const Headers({super.key, required this.headerName});

  final String headerName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 0.0),
      child: Text(
        headerName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
    );
  }
}
