import 'package:flutter/material.dart';
import 'package:jiak_users_app/provider/cart_provider.dart';
import 'package:provider/provider.dart';

import '../models/cartItem.dart';
import '../widgets/dialogs/successful_dialog.dart';

class CartCheckout extends StatefulWidget {
  final Map<String, dynamic> selectedSellerInformation;
  const CartCheckout({Key? key, required this.selectedSellerInformation});

  @override
  State<CartCheckout> createState() => _CartCheckoutState();
}

class _CartCheckoutState extends State<CartCheckout> {
  @override
  Widget build(BuildContext context) {
    print(widget.selectedSellerInformation);
    final cartProvider = Provider.of<CartProvider>(context);
    print(cartProvider.cartItems);

    // Calculate Total Price of Menu Items in the Cart
    double totalCartPrice = 0.0;
    for (final menuItem in cartProvider.cartItems) {
      final cartItemsTotalPrice = menuItem['menuPrice'] * menuItem['quantity'];
      totalCartPrice += cartItemsTotalPrice;
    }

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
      body: Column(
        children: [
          // Header - Order Summary
          Container(
            width: MediaQuery.of(context).size.width * 0.92,
            height: MediaQuery.of(context).size.height * 0.05,
            // color: Colors.black12,
            alignment: Alignment.centerLeft,
            child: Text(
              'Order Summary:',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.040,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // Display Menu Items In Cart
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.67,
            child: ListView.builder(
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  final menuItem = cartProvider.cartItems[index];
                  final menuItemTotalQuantityPrice =
                      menuItem['menuPrice'] * menuItem['quantity'];

                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        elevation: 1,
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            menuItem['menuTitle'],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                              'Quantity: ${menuItem['quantity'].toString()}'),
                          trailing: Text(
                            '\$${menuItemTotalQuantityPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          // Check Out Button
          Container(
            color: Colors.black12,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.155,
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5.0),
                  child: Text(
                    'Total: \$${totalCartPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  )),
              ElevatedButton(
                onPressed: () {
                  SuccessfulDialog.show(context, "Checkout Complete.");
                },
                child: const Text(
                  'Check Out',
                  style: TextStyle(fontSize: 16.0, color: Colors.black87),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
