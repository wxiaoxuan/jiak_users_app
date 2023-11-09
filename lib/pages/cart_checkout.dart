import 'package:flutter/material.dart';
import 'package:jiak_users_app/provider/cart_provider.dart';
import 'package:jiak_users_app/resources/global.dart';
import 'package:jiak_users_app/widgets/cart_item_list.dart';
import 'package:jiak_users_app/widgets/components/enter_button.dart';
import 'package:jiak_users_app/widgets/components/header.dart';
import 'package:jiak_users_app/widgets/dialogs/error_dialog.dart';
import 'package:provider/provider.dart';

import '../models/cartItem.dart';
import '../models/carts.dart';
import '../resources/mongoDB.dart';
import '../widgets/dialogs/successful_dialog.dart';

class CartCheckout extends StatefulWidget {
  const CartCheckout({super.key});

  @override
  State<CartCheckout> createState() => _CartCheckoutState();
}

class _CartCheckoutState extends State<CartCheckout> {
  final customerName = sharedPreferences?.get('name');
  final customerEmail = sharedPreferences?.get('email');

  // =============== Insert User's Current Cart into DB ======================
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
      timestamp: DateTime.now(),
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

  // =========== Store Cart Data in Provider for My Order Page ==============
  void processCartData(double totalCartPrice) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    List<Carts> newOrders = [];

    // Group cart items by seller ID
    Map<String, List<Map<String, dynamic>>> sellerGroupedItems = {};

    for (var cartItem in cartProvider.cartItems) {
      final sellerID = cartItem['sellerID'];

      if (!sellerGroupedItems.containsKey(sellerID)) {
        sellerGroupedItems[sellerID] = [];
      }
      sellerGroupedItems[sellerID]?.add(cartItem);
    }

    // Create a Carts object for each seller group
    sellerGroupedItems.forEach((sellerID, items) {
      final seller = items[
          0]; // Assuming seller information is the same for all items in a group

      final List<CartItem> cartItems = items.map((item) {
        return CartItem(
          menuItemID: item['menuID'].toString(),
          menuItemName: item['menuTitle'],
          menuItemPrice: item['menuPrice'],
          menuItemQuantity: item['quantity'],
        );
      }).toList();

      final cart = Carts(
        sellerID: seller['sellerID'].toString(),
        sellerName: seller['sellerName'],
        customerName: customerName.toString(),
        customerEmail: customerEmail.toString(),
        cartTotalPrice: totalCartPrice,
        cartItems: cartItems,
        timestamp: DateTime.now(),
      );

      newOrders.add(cart);
    });

    // Store the Cart Data in Provider's LatestOrder to display in My Order Page
    cartProvider.setLatestOrder(newOrders);

    // Clear Cart
    cartProvider.clearCart();
    totalCartPrice = 0.0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Calculate Total Price of Menu Items in the Cart
    double totalCartPrice = cartProvider.calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        title: const Text("Cart"),
        titleTextStyle: const TextStyle(
          color: Color(0xff3e3e3c),
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display Empty Cart UI
          if (cartProvider.cartItems.isEmpty)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Cart is currently empty.'),
                ],
              ),
            ),

          // Header - Order Summary
          if (cartProvider.cartItems.isNotEmpty)
            const HeaderTextStyle(text: 'Order Summary'),

          // Display Menu Items In Cart
          const CartItemList(),

          const Divider(),

          // Check Out Button
          SizedBox(
            // color: Colors.black12,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    'Total: \$${totalCartPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
              ),
              EnterButton(
                name: 'Check Out',
                onPressed: () async {
                  await insertCartIntoDB(context, totalCartPrice);
                  processCartData(totalCartPrice);
                },
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     await insertCartIntoDB(context, totalCartPrice);
              //     processCartData(totalCartPrice);
              //   },
              //   child: const Text(
              //     'Check Out',
              //     style: TextStyle(fontSize: 16.0, color: Colors.black87),
              //   ),
              // ),
            ]),
          ),
        ],
      ),
    );
  }
}