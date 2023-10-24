import 'package:flutter/material.dart';
import 'package:jiak_users_app/provider/cart_provider.dart';
import 'package:jiak_users_app/resources/global.dart';
import 'package:jiak_users_app/widgets/dialogs/error_dialog.dart';
import 'package:provider/provider.dart';

import '../models/cartItem.dart';
import '../models/carts.dart';
import '../widgets/dialogs/successful_dialog.dart';
import '../resources/mongoDB.dart';

class CartCheckout extends StatefulWidget {
  const CartCheckout({super.key});

  @override
  State<CartCheckout> createState() => _CartCheckoutState();
}

class _CartCheckoutState extends State<CartCheckout> {
  final customerName = sharedPreferences?.get('name');
  final customerEmail = sharedPreferences?.get('email');

  // Insert User's Current Cart into DB
  Future<void> insertCartIntoDB(
      BuildContext context, double totalCartPrice) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Prepare a list of CartItems objects based on the Items in the Cart
    final List<CartItem> cartItems = cartProvider.cartItems.map((menuItem) {
      return CartItem(
        menuItemID: menuItem['menuID'].toString(),
        menuItemName: menuItem['menuTitle'],
        menuItemPrice: menuItem['menuPrice'],
        menuItemQuantity: menuItem['quantity'],
      );
    }).toList();

    final cart = Carts(
      sellerID: cartProvider.cartItems[0]['sellerID'].toString(),
      sellerName: cartProvider.cartItems[0]['sellerName'],
      customerName: customerName.toString(),
      customerEmail: customerEmail.toString(),
      cartTotalPrice: totalCartPrice,
      cartItems: cartItems,
    );

    try {
      // Connect to DB & Insert Cart
      await MongoDB.connectCollectionCart();
      await MongoDB.insertCart(cart);
      SuccessfulDialog.show(context, "Checkout Complete.");
    } catch (e) {
      ErrorDialog.show(context, "Error inserting cart into DB: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    // print(cartProvider.cartItems);

    // Calculate Total Price of Menu Items in the Cart
    double totalCartPrice = 0.0;
    for (final menuItem in cartProvider.cartItems) {
      final cartItemsTotalPrice = menuItem['menuPrice'] * menuItem['quantity'];
      totalCartPrice += cartItemsTotalPrice;
    }

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.yellow[800],
        title: const Text("Cart"),
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
            child:
                Consumer<CartProvider>(builder: (context, cartProvider, child) {
              return ListView.builder(
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
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
                  });
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
                  insertCartIntoDB(context, totalCartPrice);
                  cartProvider.clearCart();
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
