import 'package:flutter/material.dart';
import 'package:jiak_users_app/resources/global.dart';
import 'package:jiak_users_app/resources/mongoDB.dart';
import 'package:jiak_users_app/widgets/dialogs/error_dialog.dart';

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
    print("currentOrder");
    print(currentOrder);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        title: const Text('Order Delivery Page'),
        titleTextStyle: const TextStyle(
            color: Color(0xff3e3e3c),
            fontSize: 18.0,
            fontWeight: FontWeight.w500),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (currentOrder.isNotEmpty) const SizedBox(height: 20.0),
          Expanded(
              child: ListView.builder(
                  itemCount: currentOrder.length,
                  itemBuilder: (BuildContext context, int index) {
                    final order = currentOrder[index];
                    print("order");
                    print(order);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // for (var cartItem in order['cartItems'])
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Seller Name
                              Text(
                                '${order['sellerName']}',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),

                              // Cart Total Price
                              Row(
                                children: [
                                  Text(
                                    'Total: ',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.040,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  // Menu Item Price
                                  Text(
                                    '\$${(order['cartTotalPrice'] is double) ? order['cartTotalPrice'].toStringAsFixed(2) : order['cartTotalPrice']}',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.038,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0),

                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: order['cartItems'].length,
                                  itemBuilder:
                                      (BuildContext context, int menuIndex) {
                                    final cartItem =
                                        order['cartItems'][menuIndex];

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Menu Item Name
                                        Text(
                                          '${cartItem['menuItemName']}',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),

                                        Row(
                                          children: [
                                            Text(
                                              'Price: ',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.040,
                                                // fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            // Menu Item Price
                                            Text(
                                              '\$${(cartItem['menuItemPrice'] is double) ? cartItem['menuItemPrice'].toStringAsFixed(2) : cartItem['menuItemPrice']}',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.038,
                                                // fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            Text(
                                              'Quantity: ',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.040,
                                                // fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            // Menu Item Price
                                            Text(
                                              '${(cartItem['menuItemQuantity'] is double) ? cartItem['menuItemQuantity'].toStringAsFixed(2) : cartItem['menuItemQuantity']}',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.038,
                                                // fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                      ],
                                    );
                                  }),
                              Divider(),
                              const SizedBox(height: 30.0),
                            ],
                          ),
                        ),
                      ],
                    );
                  })),
          Container(
            color: Colors.grey,
            height: 150.0,
            child: // Cart Total Price
                Row(
              children: [
                Text(
                  'Total: ',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.040,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                // Menu Item Price
                // Text(
                //   '\$${(order['cartTotalPrice'] is double) ? order['cartTotalPrice'].toStringAsFixed(2) : order['cartTotalPrice']}',
                //   style: TextStyle(
                //     fontSize: MediaQuery.of(context).size.width * 0.038,
                //     fontWeight: FontWeight.w600,
                //     color: Colors.black87,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Text(
// 'Booking ID: ',
// style: TextStyle(
// fontSize: MediaQuery.of(context).size.width * 0.04,
// fontWeight: FontWeight.w600,
// color: Colors.black87,
// ),
// ),
// Text(
// 'Delivery Guy Name: ',
// style: TextStyle(
// fontSize: MediaQuery.of(context).size.width * 0.04,
// fontWeight: FontWeight.w600,
// color: Colors.black87,
// ),
// ),
// Text(
// 'Restaurant to Customer Address ',
// style: TextStyle(
// fontSize: MediaQuery.of(context).size.width * 0.04,
// fontWeight: FontWeight.w600,
// color: Colors.black87,
// ),
// ),
// Text(
// 'Order Summary ',
// style: TextStyle(
// fontSize: MediaQuery.of(context).size.width * 0.04,
// fontWeight: FontWeight.w600,
// color: Colors.black87,
// ),
// ),

// Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     // Seller Name
//     Text(
//       '${currentOrder[0]['sellerName']}',
//       style: TextStyle(
//         fontSize: MediaQuery.of(context).size.width * 0.04,
//         fontWeight: FontWeight.w600,
//         color: Colors.black87,
//       ),
//     ),
//
//     // Cart Total Price
//     Row(
//       children: [
//         Text(
//           'Cart Total Price: ',
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.040,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         // Menu Item Price
//         Text(
//           '\$${(currentOrder[0]['cartTotalPrice'] is double) ? currentOrder[0]['cartTotalPrice'].toStringAsFixed(2) : currentOrder[0]['cartTotalPrice']}',
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.038,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     ),
//   ],
// ),
