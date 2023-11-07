import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiak_users_app/resources/global.dart';
import 'package:jiak_users_app/resources/mongoDB.dart';

import '../widgets/customDrawer.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final currentLoginUser = sharedPreferences?.get("name");
  final List<Map<String, dynamic>> currentOrder = [];

  @override
  void initState() {
    super.initState();
    retrieveCurrentOrder();
  }

  // Retrieve My Order
  Future<void> retrieveCurrentOrder() async {
    try {
      // Connect & Retrieve All User's Order
      MongoDB.connectCollectionCart();
      final allOrders = await MongoDB.getCartDocuments();
      print("===allOrders===");
      print(allOrders);

      // Retrieve Current User's Order
      for (final currentUserOrder in allOrders) {
        final dbCustomerName = currentUserOrder['customerName'];

        if (currentLoginUser == dbCustomerName) {
          currentOrder.add(currentUserOrder);
        }
      }

      // Load & Display Immediately
      setState(() {
        currentOrder;
      });
    } catch (e) {
      // ErrorDialog.show(context, 'Error connecting to MongoDb.');
      print('Error connecting to MongoDb.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("currentOrder");
    // print(currentOrder);
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        // backgroundColor: Colors.yellow[800],
        title: const Text('Orders - History'),
        titleTextStyle: const TextStyle(
            color: Color(0xff3e3e3c),
            fontSize: 18.0,
            fontWeight: FontWeight.w500),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (currentOrder.isNotEmpty)
            // const Divider(),
            const SizedBox(height: 10.0),
          Expanded(
              child: ListView.builder(
                  itemCount: currentOrder.length,
                  itemBuilder: (BuildContext context, int index) {
                    final order = currentOrder[index];
                    // print("order");
                    // print(order);

                    // Format the timestamp to your desired format
                    DateTime timestamp = order['timestamp'];
                    final date = DateFormat('dd-MM-yyyy').format(timestamp);

                    final hour = DateFormat('HH').format(timestamp);
                    final minute = DateFormat('mm').format(timestamp);

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              // Seller Name
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${order['sellerName']}',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  // Total Cart Price
                                  Text(
                                    'Total: \$${(order['cartTotalPrice'] is double) ? order['cartTotalPrice'].toStringAsFixed(2) : order['cartTotalPrice']}',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.038,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20.0),

                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: order['cartItems'].length,
                                  itemBuilder:
                                      (BuildContext context, int menuIndex) {
                                    final cartItem =
                                        order['cartItems'][menuIndex];

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Menu Item Quantity
                                        Text(
                                          '${(cartItem['menuItemQuantity'] is double) ? cartItem['menuItemQuantity'].toStringAsFixed(2) : cartItem['menuItemQuantity']}X',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 50.0),
                                        // Menu Item Name
                                        Expanded(
                                          child: Text(
                                            '${cartItem['menuItemName']}',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                            ),
                                          ),
                                        ),
                                        // Menu Item Price
                                        Text(
                                          '\$${(cartItem['menuItemPrice'] is double) ? cartItem['menuItemPrice'].toStringAsFixed(2) : cartItem['menuItemPrice']}',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                              const SizedBox(height: 20.0),
                              // Timestamp
                              Row(
                                children: [
                                  Text(
                                    'Date: ',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.028,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    date,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.028,
                                        color: Colors.black54),
                                  ),
                                  const SizedBox(width: 30.0),
                                  Text(
                                    'Time:',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.028,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    '${hour}:${minute}',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.028,
                                        color: Colors.black54),
                                  ),
                                ],
                              ),

                              // Booking ID Reference
                              Row(
                                children: [
                                  Text(
                                    'Booking ID: ',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.028,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    currentOrder[0]['_id'].toString(),
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.028,
                                        color: Colors.black54),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5.0),
                              const Divider(),
                              const SizedBox(height: 5.0),
                            ],
                          ),
                        ),
                      ],
                    );
                  })),
        ],
      ),
    );
  }
}