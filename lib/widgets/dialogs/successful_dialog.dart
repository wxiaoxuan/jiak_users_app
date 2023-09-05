import 'package:flutter/material.dart';

class SuccessfulDialog extends StatelessWidget {
  const SuccessfulDialog({super.key, required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(
        message!,
        style: const TextStyle(
          fontSize: 15.0,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child: const Center(
            child: Text(
              "OK",
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        )
      ],
    );
  }

  // Function to show the dialog
  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessfulDialog(message: message);
      },
    );
  }
}
