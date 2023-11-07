import 'package:flutter/material.dart';

import 'home.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Confirmation"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            const Text(
              "Thank you for your order!",
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              icon: const Icon(
                  Icons.check_circle_outline), //icon data for elevated button
              label: const Text("Back to Home"), //label text
            ),
          ],
        ),
      ),
    );
  }
}