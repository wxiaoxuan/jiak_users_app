// 3. Selected Menu Item's page
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:jiak_users_app/pages/shopping_cart.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import '../resources/global.dart';
import 'menuList.dart';

class MenuItemDetails extends StatefulWidget {
  final Map<String, dynamic> menuItem; // Selected Menu Item From MenuList
  final List<Map<String, dynamic>> shoppingCartItems;
  final Map<String, dynamic>
      seller; // Seller Information from Current USer (Login)

  const MenuItemDetails(
      {Key? key,
      required this.menuItem,
      required this.shoppingCartItems,
      required this.seller})
      : super(key: key);

  @override
  State<MenuItemDetails> createState() => _MenuItemDetailsState();
}

class _MenuItemDetailsState extends State<MenuItemDetails> {
  String currentUser = sharedPreferences!.getString('email') ?? 'No email';

  final List<Map<String, dynamic>> shoppingCartItems = [];

  // ========================= ADD TO CART  =================================
  TextEditingController itemQuantityController = TextEditingController();
  late int shoppingCartItemsCounter = 0;

  void addItemToCart(String? foodItemID, int itemCounter) {
    // Check if item is alr in the cart by ID
    bool itemExistsInCart = false;

    for (final shoppingCartItem in widget.shoppingCartItems) {
      if (shoppingCartItem['_id'] == foodItemID) {
        shoppingCartItem['quantity'] += itemCounter;
        itemExistsInCart = true;
        break;
      }
    }

    // If Item is not in the cart, Add it
    if (!itemExistsInCart) {
      widget.shoppingCartItems.add({
        '_id': foodItemID,
        'menuItem': widget.menuItem['menuTitle'],
        'menuPrice': widget.menuItem['menuPrice'],
        'quantity': itemCounter,
        // Add other item details here if needed
      });
    }

    setState(() {
      shoppingCartItemsCounter += itemCounter;
      print(shoppingCartItemsCounter);
    });

    // Clear itemQuantityController text field
    itemQuantityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // =============================== IMAGE ==================================
    Uint8List? imageBytes;
    final menuItemID = widget.menuItem['_id']?.toString() ?? "";
    if (widget.menuItem.containsKey('image')) {
      final imageInfo = widget.menuItem['image'] as Map<String, dynamic>;
      final base64Image = imageInfo['imageData'] as String?;

      // Decode the base64-encoded image data
      if (base64Image != null) {
        imageBytes = base64.decode(base64Image);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        title: Text('${widget.menuItem['menuTitle']}'),
        titleTextStyle: const TextStyle(
            color: Color(0xff3e3e3c),
            fontSize: 18.0,
            fontWeight: FontWeight.w500),
        centerTitle: true,
        actions: [
          // Add to Shopping Cart Icon
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShoppingCart(
                          shoppingCartItems: widget.shoppingCartItems,
                          seller: widget.seller),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_bag_outlined),
              ),
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
                          shoppingCartItemsCounter.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ))
                ],
              ))
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            // Image
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
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
            ),
            const SizedBox(height: 50.0),
            // Title  & Description
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Text(
                        '${widget.menuItem['menuTitle']}',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      // Price
                      Text(
                        '\$${(widget.menuItem['menuPrice'] is double) ? widget.menuItem['menuPrice'].toStringAsFixed(2) : widget.menuItem['menuPrice']}',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  // Menu Item's Information
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      '${widget.menuItem['menuInformation']}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  // Item Quantities
                  Padding(
                    padding: const EdgeInsets.only(left: 100, right: 100.0),
                    child: NumberInputPrefabbed.roundedButtons(
                      controller: itemQuantityController,
                      incDecBgColor: Colors.amber,
                      min: 1,
                      max: 20,
                      initialValue: 1,
                      buttonArrangement: ButtonArrangement.incRightDecLeft,
                      incIcon: Icons.add,
                      decIcon: Icons.remove,
                      incIconColor: Colors.white,
                      decIconColor: Colors.white,
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  // Add to cart Button
                  ElevatedButton(
                    onPressed: () {
                      int itemCounter = int.parse(itemQuantityController.text);

                      // Add to cart
                      addItemToCart(menuItemID, itemCounter);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuList(
                              seller: widget.seller, // Seller data goes here
                              shoppingCartItems: widget.shoppingCartItems,
                              shoppingCartItemsCounter:
                                  shoppingCartItemsCounter),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[800],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100.0, vertical: 12.0)),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
