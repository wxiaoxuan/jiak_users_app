import 'package:flutter/material.dart';
import 'package:jiak_users_app/pages/cart_checkout.dart';
import 'package:jiak_users_app/widgets/dialogs/error_dialog.dart';
import 'package:jiak_users_app/widgets/homeWidgets/iconTextItem.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../resources/mongoDB.dart';
import '../widgets/components/customDrawer.dart';
import '../widgets/homeWidgets/headers.dart';
import '../widgets/homeWidgets/sellerListHorizontal.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    retrieveAllSellerInformation(); // Fetch seller information when the widget is created
  }

  List<Map<String, dynamic>> listOfSellers = []; // Initialize

  // Retrieve All Seller's Information
  Future<void> retrieveAllSellerInformation() async {
    try {
      // Connect to DB & Get Seller's Information
      MongoDB.connectSeller();
      final dbSellers = await MongoDB.getSellersDocument();

      // Load Immediately
      setState(() {
        listOfSellers = dbSellers;
      });
    } catch (e) {
      ErrorDialog.show(context, "Error retrieving All Seller's Information.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        // backgroundColor: Colors.yellow[800],
        title: const Text('Home'),
        titleTextStyle: const TextStyle(
            color: Color(0xff3e3e3c),
            fontSize: 18.0,
            fontWeight: FontWeight.w500),
        centerTitle: true,
        actions: [
          // Add to Shopping Cart Icon
          Consumer<CartProvider>(builder: (context, cartProvider, child) {
            int itemCount = cartProvider.getTotalItemCount();
            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartCheckout()),
                    );
                  },
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                  ),
                ),
                // if (itemCount > 0)
                Positioned(
                    child: Stack(
                      children: [
                        const Icon(
                          Icons.brightness_1,
                          size: 20.0,
                          color: Colors.deepOrangeAccent,
                        ),
                        Positioned(
                            top: 1,
                            right: 6,
                            child: Center(
                              child: Text(
                                itemCount.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ))
                      ],
                    ))
              ],
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const Headers(headerName: 'Food Delivery'),

            // Display Icons in a Row
            const Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconTextItem(icon: Icons.local_drink, text: 'Beverages'),
                      IconTextItem(icon: Icons.wine_bar, text: 'Alcohol'),
                      IconTextItem(icon: Icons.fastfood, text: 'Fast Food'),
                      IconTextItem(
                          icon: Icons.restaurant_menu, text: 'Restaurants'),
                      // IconTextItem(icon: Icons.adb, text: 'Korean'),
                    ],
                  ),
                ),
              ],
            ),

            // Tabs
            Row(
              children: [
                // Shops Tab
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 10.0, bottom: 10.0),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.45,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.28,
                    // color: Colors.lightBlueAccent,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey,
                      boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Heading
                        const Padding(
                          padding: EdgeInsets.only(top: 30.0, left: 20.0),
                          child: Text(
                            "Shops",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Subheading
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Explore more now!",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Button
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 45.0, top: 110.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Shop here',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 18.0,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    // Pick Up Tab
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 0.0, bottom: 10.0),
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.45,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.17,
                        // color: Colors.lightBlueAccent,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 1)
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Heading
                            Padding(
                              padding: EdgeInsets.only(top: 30.0, left: 20.0),
                              child: Text(
                                "Pickup",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Subheading
                            Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Explore more now!",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // JiakMart Tab
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 0.0, bottom: 10.0),
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.45,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.1,
                        // color: Colors.lightBlueAccent,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 1)
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Heading
                            Padding(
                              padding: EdgeInsets.only(top: 20.0, left: 20.0),
                              child: Text(
                                "JiakMart",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Subheading
                            Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Explore more now!",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10.0),

            // Heading - Top Picks
            const Headers(headerName: 'Top Picks'),

            // List of Sellers - Top Picks Category
            SellerListHorizontal(listOfSellers: listOfSellers),

            // Heading - Support Your Locals
            const Headers(headerName: 'Support Your Local!'),

            // List of Sellers - Support Your Locals Category
            SellerListHorizontal(listOfSellers: listOfSellers),

            const SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }
}