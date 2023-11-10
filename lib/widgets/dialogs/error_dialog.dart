import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget {
  const ErrorDialog({Key? key, this.message});

  final String? message;

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();

  // Static method to show the dialog
  static void showWithTimer(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }

  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  void initState() {
    super.initState();
    closeDialogAfterDelay();
  }

  void closeDialogAfterDelay() async {
    const duration = Duration(seconds: 3);
    await Future.delayed(duration); // wait for specified duration

    // Check if widget is still mounted before popping the navigation
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: widget.key,
      content: Text(
        widget.message!,
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
}