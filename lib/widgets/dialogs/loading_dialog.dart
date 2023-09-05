import 'package:flutter/material.dart';
import '../dialogs/progress_bar.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key, required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        key: key,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            circularProgress(),
            const SizedBox(height: 10.0),
            Text('${message!}, please hold.')
          ],
        ));
  }

  // Function to show the dialog
  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoadingDialog(message: message);
      },
    );
  }
}
