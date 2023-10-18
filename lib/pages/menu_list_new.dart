import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jiak_users_app/pages/homeNew.dart';
import 'package:jiak_users_app/pages/menu_item_details_new.dart';
import 'package:jiak_users_app/provider/cart_provider.dart';
import 'package:jiak_users_app/widgets/dialogs/error_dialog.dart';
import 'package:provider/provider.dart';

import '../resources/mongoDB.dart';

class SellerMenuList extends StatefulWidget {
  final Map<String, dynamic> selectedSellerInformation;
  const SellerMenuList({super.key, required this.selectedSellerInformation});

  @override
  State<SellerMenuList> createState() => _SellerMenuListState();
}

class _SellerMenuListState extends State<SellerMenuList> {
  @override
  void initState() {
    super.initState();
    retrieveSelectedSellerMenu();
  }

  // =============== Retrieve Selected Seller's Menu List =====================
  final List<Map<String, dynamic>> selectedSellerMenuList = [];

  Future<void> retrieveSelectedSellerMenu() async {
    try {
      selectedSellerMenuList.clear();

      // Connect & retrieve All seller's menu DB
      MongoDB.connectCollectionMenu();
      final allSellersMenu = await MongoDB.getMenuDocuments();

      // Retrieve selected seller menu list
      for (final selectedSellerMenu in allSellersMenu) {
        final dbMenuOwnerID = selectedSellerMenu['sellerID'];
        final selectedSellerID =
            widget.selectedSellerInformation['_id'].toString();

        if (selectedSellerID == dbMenuOwnerID) {
          selectedSellerMenuList.add(selectedSellerMenu);
        }
      }

      // Load & display immediately
      setState(() {
        selectedSellerMenuList;
      });
    } catch (e) {
      ErrorDialog.show(context, 'Error retrieving selected seller\'s menu');
      print('Error retrieving selected seller\'s menu.');
    }
  }

  // ==========================================================================
  @override
  Widget build(BuildContext context) {
    // Access the seller information from the widget
    Map<String, dynamic> selectedSellerInformation =
        widget.selectedSellerInformation;
    // print("=================sellerInformation=============================");
    // print(selectedSellerInformation);

    return Scaffold(
      appBar: AppBar(
        leading:
            // Back Button
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                },
                icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.yellow[800],
        title: Text('${widget.selectedSellerInformation['name']}\'s Menu'),
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ShoppingCart(
                    //         shoppingCartItems: widget.shoppingCartItems,
                    //         seller: widget.seller),
                    //   ),
                    // );
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
                      color: Colors.green,
                    ),
                    Positioned(
                        top: 1,
                        right: 6,
                        child: Center(
                          child: Text(
                            itemCount.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ))
                  ],
                ))
              ],
            );
          }),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            // Simulate loading delay with a Future.delayed
            future: Future.delayed(const Duration(seconds: 0), () {}),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While loading, show a centered loading indicator
                return const Center(
                    heightFactor: 20, child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // If there's an error, display an error message
                return Center(
                    heightFactor: 20, child: Text('Error: ${snapshot.error}'));
              } else {
                // Once the loading is complete, display the content
                return selectedSellerMenuList.isEmpty
                    // Menu List is Empty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 300.0, horizontal: 100.0),
                          child: Text(
                            'Menu List is empty',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      )
                    :
                    // Menu List Not Empty
                    Expanded(
                        child: ListView.builder(
                          itemCount: selectedSellerMenuList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final menu = selectedSellerMenuList[index];
                            Uint8List? imageBytes;

                            // Check if 'image' field is present in the seller data
                            if (menu.containsKey('image')) {
                              final imageInfo =
                                  menu['image'] as Map<String, dynamic>;
                              final base64Image =
                                  imageInfo['imageData'] as String?;

                              // Decode the base64-encoded image data
                              if (base64Image != null) {
                                imageBytes = base64.decode(base64Image);
                              }
                            }

                            return GestureDetector(
                              onTap: () {
                                // Navigate to Selected Menu Item's Info Page
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SelectedMenuItemDetails(
                                              selectedSellerInformation:
                                                  selectedSellerInformation,
                                              selectedMenuItem: menu,
                                            )));
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => MenuItemDetails(
                                //           menuItem: menu,
                                //           shoppingCartItems:
                                //           widget.shoppingCartItems,
                                //           seller: widget.seller,
                                //         )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 20.0, bottom: 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // Image
                                        Container(
                                          width: 90.0,
                                          height: 90.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            // Adjust the borderRadius as needed
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: MemoryImage(imageBytes!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        // Menu Item
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Menu Item Name
                                              Text(
                                                '${menu['menuTitle']}',
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.040,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),

                                              // Menu Item Description
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.65,
                                                child: Text(
                                                  '${menu['menuInformation']}',
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.030,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 3.0),

                                              // Menu Item Price and Add To Cart Button
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.65,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    // Menu Item Price
                                                    Text(
                                                      '\$${(menu['menuPrice'] is double) ? menu['menuPrice'].toStringAsFixed(2) : menu['menuPrice']}',
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.038,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black87,
                                                      ),
                                                    ),

                                                    // Add to Cart Button
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                          Icons
                                                              .add_circle_outline,
                                                          color: Colors.black54,
                                                          // size: 24.0,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3.0),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
              }
            },
          ),
        ],
      ),
    );
  }
}
