import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiak_users_app/resources/global.dart';
import 'package:jiak_users_app/resources/mongoDB.dart';
import 'package:jiak_users_app/widgets/orderHistory_widgets/date_time.dart';

import '../widgets/components/customDrawer.dart';
import '../widgets/orderHistory_widgets/menuItem_text.dart';

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
    // print(currentOrder);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        // backgroundColor: const Color(0xFFF5F3F0),
        title: const Text('Orders - History'),
        titleTextStyle: const TextStyle(
            color: Color(0xff3e3e3c),
            fontSize: 18.0,
            fontWeight: FontWeight.w500),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (currentOrder.isNotEmpty) const SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: currentOrder.length,
              itemBuilder: (BuildContext context, int index) {
                final order = currentOrder[index];

                // Format the timestamp to your desired format
                DateTime timestamp = order['timestamp'];
                final date = DateFormat('dd-MM-yyyy').format(timestamp);
                final time = DateFormat('HH:mm').format(timestamp);

                return Card(
                  elevation: 3,
                  color: const Color(0xFFF5F3F0),
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Seller Name & Total Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${order['sellerName']}',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            // Total Cart Price
                            Text(
                              'Total: \$${(order['cartTotalPrice'] is double) ? order['cartTotalPrice'].toStringAsFixed(2) : order['cartTotalPrice']}',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10.0),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: order['cartItems'].length,
                          itemBuilder: (BuildContext context, int menuIndex) {
                            final cartItem = order['cartItems'][menuIndex];

                            // Menu Item's  Quantity, Name & Price
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MenuItemText(
                                    text:
                                        '${(cartItem['menuItemQuantity'] is double) ? cartItem['menuItemQuantity'].toStringAsFixed(2) : cartItem['menuItemQuantity']}X'),
                                const SizedBox(width: 50.0),
                                Expanded(
                                  child: MenuItemText(
                                      text: '${cartItem['menuItemName']}'),
                                ),
                                MenuItemText(
                                    text:
                                        '\$${(cartItem['menuItemPrice'] is double) ? cartItem['menuItemPrice'].toStringAsFixed(2) : cartItem['menuItemPrice']}'),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20.0),

                        // Timestamp
                        Row(
                          children: [
                            const DateTimeTextStyle(
                                text: 'Date: ', fontWeight: FontWeight.w600),
                            const SizedBox(width: 5.0),
                            DateTimeTextStyle(
                                text: date, fontWeight: FontWeight.normal),
                            const SizedBox(width: 30.0),
                            const DateTimeTextStyle(
                                text: 'Time:', fontWeight: FontWeight.w600),
                            const SizedBox(width: 5.0),
                            DateTimeTextStyle(
                              text: time,
                              fontWeight: FontWeight.normal,
                            ),
                          ],
                        ),

                        // Booking ID Reference
                        Row(
                          children: [
                            const DateTimeTextStyle(
                                text: 'Booking ID: ',
                                fontWeight: FontWeight.w600),
                            const SizedBox(width: 5.0),
                            DateTimeTextStyle(
                                text: currentOrder[0]['_id'].toString(),
                                fontWeight: FontWeight.normal),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
