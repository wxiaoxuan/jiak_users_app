import 'package:flutter/material.dart';
import 'package:jiak_users_app/resources/global.dart';
import 'package:jiak_users_app/resources/mongoDB.dart';
import 'package:jiak_users_app/widgets/dialogs/error_dialog.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({Key? key}) : super(key: key);

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
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
    // Sort currentOrders by timestamp in descending order
    currentOrder.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    print("currentOrder");
    print(currentOrder);
    // print(currentOrder[0]['_id'].toString());

    if (currentOrder.isNotEmpty) {
      final latestOrder = currentOrder.first;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking ID Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 10.0),
                  // Order Summary Header
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: // Cart Total Price
                        Text(
                      'Booking ID: ',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),

                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      currentOrder[0]['_id'].toString(),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                    ),
                  ),
                  // Divider(),
                ],
              ),
            ),
            // Delivery Rider Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 10.0),
                  // Delivery Rider Name
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Delivery Rider: ',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 5.0),
                  // Delivery Rider Layout
                  Row(
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        'Rating',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                        ),
                      ),
                      const SizedBox(width: 180.0),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.message_outlined)),
                      const SizedBox(width: 10.0),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.phone)),
                    ],
                  ),
                ],
              ),
            ),
            // Address
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 10.0),
                  // Order Summary Header
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: // Cart Total Price
                        Text(
                      'Address: ',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),

                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'From: ',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'To: ',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                    ),
                  ),
                  // Divider(),
                ],
              ),
            ),
            // Order Summary Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 10.0),
                  // Order Summary Header
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: // Cart Total Price
                        Text(
                      'Order Summary: ',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.040,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Divider(),
                ],
              ),
            ),
            // Cart Item Information
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seller Name
                    Text(
                      '${latestOrder['sellerName']}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10.0),

                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: latestOrder['cartItems'].length,
                        itemBuilder: (BuildContext context, int menuIndex) {
                          final cartItem = latestOrder['cartItems'][menuIndex];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${(cartItem['menuItemQuantity'] is double) ? cartItem['menuItemQuantity'].toStringAsFixed(2) : cartItem['menuItemQuantity']}X',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    '${cartItem['menuItemName']}',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                    ),
                                  ),
                                  // Menu Item Price
                                  Text(
                                    '\$${(cartItem['menuItemPrice'] is double) ? cartItem['menuItemPrice'].toStringAsFixed(2) : cartItem['menuItemPrice']}',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          );
                        }),
                    const Divider(),
                    // const SizedBox(height: 30.0),
                  ],
                ),
              ),
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
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    // Menu Item Price
                    Text(
                      '\$${(latestOrder['cartTotalPrice'] is double) ? latestOrder['cartTotalPrice'].toStringAsFixed(2) : latestOrder['cartTotalPrice']}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.038,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () {
                  print("You pressed Icon Elevated Button");
                },
                icon: const Icon(
                    Icons.check_circle_outline), //icon data for elevated button
                label: const Text("Order Complete"), //label text
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      );
    } else {
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
        body: const Center(
          child: Text('No orders available.'),
        ),
      );
    }
  }
}
