import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiak_users_app/resources/global.dart';
import 'package:jiak_users_app/resources/mongoDB.dart';

import '../widgets/customDrawer.dart';
import 'order_confirmation_screen.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({Key? key}) : super(key: key);

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  final currentLoginUser = sharedPreferences?.get("name");
  final List<Map<String, dynamic>> currentOrder = [];
  bool isPageCleared = false;

  void checkAndClearData() {
    if (isPageCleared) {
      currentOrder.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveCurrentOrder();
    // checkAndClearData();
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
    print(currentOrder);

    // ====================== UI - If there's no order ========================
    if (currentOrder.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // backgroundColor: Colors.yellow[800],
          title: const Text('My Orders'),
          titleTextStyle: const TextStyle(
              color: Color(0xff3e3e3c),
              fontSize: 18.0,
              fontWeight: FontWeight.w500),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('No orders available.'),
        ),
      );
    }

    // ====== Sort currentOrders by timestamp in descending order =============
    currentOrder.sort((a, b) {
      // Handle null timestamps by using the current date and time as the default
      final aTimestamp = a['timestamp'] ?? DateTime.now();
      final bTimestamp = b['timestamp'] ?? DateTime.now();

      return bTimestamp.compareTo(aTimestamp);
    });

    //================== To get the Customer's Latest Order ===================
    final latestOrder = currentOrder.first;
    print(latestOrder);

    //  =============== Format Timestamp to be displayed  =====================
    DateTime? timestamp = latestOrder['timestamp'];
    String date = "";
    String time = "";

    if (timestamp != null) {
      date = DateFormat('dd-MM-yyyy').format(timestamp);
      time = DateFormat('HH:mm').format(timestamp);
    }
    //  =======================================================================

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        // backgroundColor: Colors.yellow[800],
        title: const Text('My Orders'),
        titleTextStyle: const TextStyle(
            color: Color(0xff3e3e3c),
            fontSize: 18.0,
            fontWeight: FontWeight.w500),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking ID Header
            const SizedBox(height: 10.0),
            // Booking ID
            Row(
              children: [
                Text(
                  'Booking ID: ',
                  style: TextStyle(
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * 0.032,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
                Text(
                  currentOrder[0]['_id'].toString(),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .width * 0.032,
                  ),
                ),
              ],
            ),

            // Timestamp
            Row(
              children: [
                Text(
                  'Date: ',
                  style: TextStyle(
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * 0.032,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
                const SizedBox(width: 5.0),
                Text(
                  date.isNotEmpty ? date : 'N/A',
                  style: TextStyle(
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * 0.032,
                      color: Colors.black54),
                ),
                const SizedBox(width: 30.0),
                Text(
                  'Time:',
                  style: TextStyle(
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * 0.032,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
                const SizedBox(width: 5.0),
                // if (displayDateTime)
                Text(
                  time.isNotEmpty ? time : 'N/A',
                  style: TextStyle(
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * 0.032,
                      color: Colors.black54),
                ),
              ],
            ),

            // Order Summary Header
            const Divider(),

            const SizedBox(height: 10.0),

            // Order Summary Header
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: // Cart Total Price
              Text(
                'Order Summary: ',
                style: TextStyle(
                  fontSize: MediaQuery
                      .of(context)
                      .size
                      .width * 0.040,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Cart Item Information
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seller Name
                    Text(
                      '${latestOrder['sellerName']}',
                      style: TextStyle(
                        fontSize: MediaQuery
                            .of(context)
                            .size
                            .width * 0.038,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 5.0),

                    if (latestOrder != null)
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (latestOrder['cartItems'] != null)
                              ? latestOrder['cartItems'].length
                              : 0,
                          itemBuilder: (BuildContext context, int menuIndex) {
                            final cartItem =
                            latestOrder['cartItems'][menuIndex];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${(cartItem['menuItemQuantity'] is double)
                                          ? cartItem['menuItemQuantity']
                                          .toStringAsFixed(2)
                                          : cartItem['menuItemQuantity']}X',
                                      style: TextStyle(
                                        fontSize:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.035,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 30.0),
                                    Expanded(
                                      child: Text(
                                        '${cartItem['menuItemName']}',
                                        style: TextStyle(
                                          fontSize: MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.035,
                                        ),
                                      ),
                                    ),
                                    // Menu Item Price
                                    Text(
                                      '\$${(cartItem['menuItemPrice'] is double)
                                          ? cartItem['menuItemPrice']
                                          .toStringAsFixed(2)
                                          : cartItem['menuItemPrice']}',
                                      style: TextStyle(
                                        fontSize:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.035,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                              ],
                            );
                          }),

                    const Divider(),
                  ]),
            ),

            const Divider(),

            // Total Price
            SizedBox(
              height: 50.0,
              child: // Cart Total Price
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ',
                      style: TextStyle(
                        fontSize: MediaQuery
                            .of(context)
                            .size
                            .width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    // Menu Item Price
                    Text(
                      '\$${(latestOrder['cartTotalPrice'] is double)
                          ? latestOrder['cartTotalPrice'].toStringAsFixed(2)
                          : latestOrder['cartTotalPrice']}',
                      style: TextStyle(
                        fontSize: MediaQuery
                            .of(context)
                            .size
                            .width * 0.038,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Order Complete Button
            Container(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isPageCleared = true;
                  });
                  currentOrder.clear();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const OrderConfirmationScreen()));
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Order Complete"), //label text
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}