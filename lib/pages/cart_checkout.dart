import 'package:flutter/material.dart';
import 'package:jiak_users_app/pages/my_order.dart';
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
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Empty Cart UI
            if (cartProvider.cartItems.isEmpty)
              const Center(
                heightFactor: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cart is currently empty.'),
                  ],
                ),
              ),

            // Header - Order Summary
            if (cartProvider.cartItems.isNotEmpty)

              // Delivery Address Header
              if (cartProvider.cartItems.isNotEmpty)
                Container(
                    color: Colors.grey.shade200,
                    width: MediaQuery.of(context).size.width,
                    child: const HeaderTextStyle(text: 'Contactless Delivery')),

            // Delivery Address
            if (cartProvider.cartItems.isNotEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0),
                      // Map
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset('assets/images/map.png'),
                      ),
                      const SizedBox(height: 10.0),
                      // Customer Address Details
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.grey.shade200,
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, color: Colors.red),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Teddy Wong ',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Neil Road 123 ',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (cartProvider.cartItems.isNotEmpty)
              Container(
                  color: Colors.grey.shade200,
                  width: MediaQuery.of(context).size.width,
                  child: const HeaderTextStyle(text: 'Cart Summary')),

            // Display Menu Items In Cart
            if (cartProvider.cartItems.isNotEmpty) const CartItemList(),

            const Divider(),

            // Payment Method
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Icon(Icons.money_rounded, color: Colors.green),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: Text(
                            'SGD ',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Text(
                          'Promo Code ',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Divider(),

            // Check Out Section
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16.0),
                        ),
                        Text(
                          '\$${cartProvider.totalCartPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: EnterButton(
                    name: 'Check Out',
                    onPressed: () async {
                      if (cartProvider.cartItems.isEmpty) {
                        ErrorDialog.showWithTimer(
                            context, 'Cart is empty. Add items to check out.');
                      } else {
                        await insertCartIntoDB(
                            context, cartProvider.totalCartPrice);
                        processCartData(cartProvider.totalCartPrice);

                        // Navigate to My Order Page
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyOrder()));
                      }
                    },
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
