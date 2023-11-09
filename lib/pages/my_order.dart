import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiak_users_app/widgets/orderHistory_widgets/date_time.dart';
import 'package:jiak_users_app/widgets/orderHistory_widgets/menuItem_text.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../widgets/components/customDrawer.dart';

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
      drawer: const CustomDrawer(),
      appBar: AppBar(
        // backgroundColor: Colors.yellow[800],
        title: const Text("My Orders"),
        titleTextStyle: const TextStyle(
          color: Color(0xff3e3e3c),
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
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
                          color: Colors.black54),
                    ),
                    // Text(
                    //   latestOrder['_id'].toString(),
                    //   style: TextStyle(
                    //     color: Colors.black54,
                    //     fontSize: MediaQuery
                    //         .of(context)
                    //         .size
                    //         .width * 0.032,
                    //   ),
                    // ),
                  ],
                ),

            const Divider(),
            const SizedBox(height: 5.0),

            // Cart Details
            for (var order in cartProvider.latestOrders)
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.latestOrders.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Format the timestamp to your desired format
                    DateTime timestamp = order.timestamp;
                    final date = DateFormat('dd-MM-yyyy').format(timestamp);
                    final time = DateFormat('HH:mm').format(timestamp);

                    return Column(
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
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10.0),

                        // Quantity + Menu Items + Menu Item's Price
                        // order.cartItems = cartProvider.latestOrders.cartItems
                        for (var menuItem in order.cartItems)
                          Row(
                            children: [
                              // Quantity
                              MenuItemText(
                                  text:
                                      '${menuItem.menuItemQuantity.toString()}X'),
                              const SizedBox(width: 50.0),
                              // Menu Item Name
                              Expanded(
                                  child: MenuItemText(
                                      text: menuItem.menuItemName)),
                              // Menu Item Price
                              MenuItemText(
                                  text:
                                      '\$${(menuItem.menuItemPrice is double) ? menuItem.menuItemPrice.toStringAsFixed(2) : menuItem.menuItemPrice}'),
                            ],
                          ),

                        const SizedBox(height: 20.0),

                        // Timestamp
                        Row(
                          children: [
                            DateTimeTextStyle(
                                text: 'Date: $date',
                                fontWeight: FontWeight.w400),
                            const SizedBox(width: 30.0),
                            DateTimeTextStyle(
                                text: 'Time: $time',
                                fontWeight: FontWeight.w400),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),

            if (cartProvider.latestOrders.isNotEmpty)
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: () {
                          cartProvider.clearLatestOrder();
                          print('latest order is cleared.');
                        },
                        child: const Text('I have received my order'),
                      ),
                    ),
                  ))
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No orders currently.'),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                        onPressed: () {}, child: const Text('Start Ordering!'))
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}