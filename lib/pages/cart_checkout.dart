import 'package:flutter/material.dart';

class CartCheckout extends StatefulWidget {
  const CartCheckout({Key? key});

  @override
  State<CartCheckout> createState() => _CartCheckoutState();
}

class _CartCheckoutState extends State<CartCheckout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.yellow[800],
        title: Text("Cart"),
        titleTextStyle: const TextStyle(
          color: Color(0xff3e3e3c),
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
    );
  }
}
