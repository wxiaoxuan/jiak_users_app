import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiak_users_app/pages/order_confirmation_screen.dart';
import 'package:jiak_users_app/widgets/components/enter_button.dart';
import 'package:jiak_users_app/widgets/orderHistory_widgets/date_time.dart';
import 'package:jiak_users_app/widgets/orderHistory_widgets/menuItem_text.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../widgets/components/customDrawer.dart';
import 'home.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("My Orders"),
        titleTextStyle: const TextStyle(
          color: Color(0xff3e3e3c),
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: Colors.yellow[800],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            // Order Summary Header
            if (cartProvider.latestOrders.isNotEmpty)
              Text(
                'Order Summary ',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.040,
                  fontWeight: FontWeight.w500,
                ),
              ),

            if (cartProvider.latestOrders.isNotEmpty)
              const SizedBox(height: 10.0),

            // Booking ID
            if (cartProvider.latestOrders.isNotEmpty)
              for (var order in cartProvider.latestOrders)
                Row(
                  children: [
                    Text(
                      'Booking ID: ',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.032,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),

            if (cartProvider.latestOrders.isNotEmpty) const Divider(),
            if (cartProvider.latestOrders.isNotEmpty)
              const SizedBox(height: 80.0),

            // Cart Details
            for (var order in cartProvider.latestOrders)
              Card(
                elevation: 3,
                // color: Colors.amber.shade100,
                color: const Color(0xFFF5F3F0),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Seller Name + Total Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order.sellerName,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Total Cart Price
                          Text(
                            'Total: \$${(order.cartTotalPrice is double) ? order.cartTotalPrice.toStringAsFixed(2) : order.cartTotalPrice}',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.038,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10.0),

                      // Quantity + Menu Items + Menu Item's Price
                      for (var menuItem in order.cartItems)
                        Row(
                          children: [
                            // Quantity
                            MenuItemText(
                                text:
                                    '${menuItem.menuItemQuantity.toString()}X'),
                            const SizedBox(width: 30.0),
                            // Menu Item Name
                            Expanded(
                                child:
                                    MenuItemText(text: menuItem.menuItemName)),
                            // Menu Item Price
                            MenuItemText(
                                text:
                                    '\$${(menuItem.menuItemPrice is double) ? menuItem.menuItemPrice.toStringAsFixed(2) : menuItem.menuItemPrice}'),
                          ],
                        ),

                      const SizedBox(height: 10.0),

                      // Timestamp
                      Row(
                        children: [
                          DateTimeTextStyle(
                              text:
                                  'Date: ${DateFormat('dd-MM-yyyy').format(order.timestamp)}',
                              fontWeight: FontWeight.w400),
                          const SizedBox(width: 30.0),
                          DateTimeTextStyle(
                              text:
                                  'Time: ${DateFormat('HH:mm').format(order.timestamp)}',
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            if (cartProvider.latestOrders.isNotEmpty)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: EnterButton(
                          name: 'Received order',
                          onPressed: () {
                            cartProvider.clearLatestOrder();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OrderConfirmationScreen()));
                          })),
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 300.0),
                    const Text(
                      'No orders currently.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 30.0),
                    EnterButton(
                        name: 'Start Ordering!',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()));
                        })
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
