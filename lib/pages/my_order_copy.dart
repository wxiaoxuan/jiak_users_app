import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../widgets/customDrawer.dart';

class MyOrderCopy extends StatefulWidget {
  // final Map<String, dynamic>? latestOrder;

  const MyOrderCopy({super.key});

  @override
  State<MyOrderCopy> createState() => _MyOrderCopyState();
}

class _MyOrderCopyState extends State<MyOrderCopy> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    print('================');
    print("cartProvider.latestOrders");
    // print(cartProvider.latestOrders[0]['sellerName']);
    print(cartProvider.latestOrders);
    // print("cartProvider.cartItems");
    // print(cartProvider.cartItems);

    return Scaffold(
      drawer: const CustomDrawer(),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            // Booking ID Header
            Row(
              children: [
                Text(
                  'Booking ID: ',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.032,
                      fontWeight: FontWeight.w600,
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
            const SizedBox(height: 10.0),

            // Order Summary Header
            Text(
              'Order Summary: ',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.040,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Expanded(
            //     child: Column(
            //   children: [
            //     // Seller Name
            //     Text(
            //       // 'Menu Title: ${latestOrder?[0]['menuTitle'] ?? 'Nil'}',
            //       '${latestOrder?[0]['sellerName'] ?? 'Nil'}',
            //       style: TextStyle(
            //         fontSize: MediaQuery.of(context).size.width * 0.036,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //     const SizedBox(height: 5.0),
            //
            //     const Divider(),
            //   ],
            // )),
          ],
        ),
      ),
    );
  }
}