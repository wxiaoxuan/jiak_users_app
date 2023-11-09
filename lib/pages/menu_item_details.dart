import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jiak_users_app/pages/menu_list.dart';
import 'package:jiak_users_app/provider/cart_provider.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';

class SelectedMenuItemDetails extends StatefulWidget {
  final Map<String, dynamic> selectedSellerInformation;
  final Map<String, dynamic> selectedMenuItem;

  const SelectedMenuItemDetails(
      {super.key,
      required this.selectedSellerInformation,
      required this.selectedMenuItem});

  @override
  State<SelectedMenuItemDetails> createState() =>
      _SelectedMenuItemDetailsState();
}

class _SelectedMenuItemDetailsState extends State<SelectedMenuItemDetails> {
  TextEditingController itemQuantityToCartController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // =============================== IMAGE ==================================
    Uint8List? imageBytes;
    final menuItemID = widget.selectedMenuItem['_id']?.toString() ?? "";
    if (widget.selectedMenuItem.containsKey('image')) {
      final imageInfo =
          widget.selectedMenuItem['image'] as Map<String, dynamic>;
      final base64Image = imageInfo['imageData'] as String?;

      // Decode the base64-encoded image data
      if (base64Image != null) {
        imageBytes = base64.decode(base64Image);
      }
    }

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
          leading:
              // Back Button
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SellerMenuList(
                                selectedSellerInformation:
                                    widget.selectedSellerInformation)));
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
          backgroundColor: Colors.yellow[800],
          title: Text('${widget.selectedMenuItem['menuTitle']}'),
          titleTextStyle: const TextStyle(
              color: Color(0xff3e3e3c),
              fontSize: 18.0,
              fontWeight: FontWeight.w500),
          centerTitle: true),
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

            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title  & Description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Text(
                        '${widget.selectedMenuItem['menuTitle']}',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      // Price
                      Text(
                        '\$${(widget.selectedMenuItem['menuPrice'] is double) ? widget.selectedMenuItem['menuPrice'].toStringAsFixed(2) : widget.selectedMenuItem['menuPrice']}',
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
                      '${widget.selectedMenuItem['menuInformation']}',
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
                      controller: itemQuantityToCartController,
                      incDecBgColor: Colors.amber,
                      min: 1,
                      max: 10,
                      initialValue: 1,
                      buttonArrangement: ButtonArrangement.incRightDecLeft,
                      incIcon: Icons.add,
                      decIcon: Icons.remove,
                      incIconColor: Colors.white,
                      decIconColor: Colors.white,
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  // Add to cart Button
                  ElevatedButton(
                    onPressed: () {
                      int itemCounter =
                          int.parse(itemQuantityToCartController.text);

                      // Access the CartProvider
                      final cartProvider =
                          Provider.of<CartProvider>(context, listen: false);

                      // Add All menu item ID and quantity to the cart icon
                      cartProvider.addToCartQuantity(menuItemID, itemCounter);

                      // Add All Menu Item Details to Cart Page
                      cartProvider.addToCart(widget.selectedSellerInformation,
                          menuItemID, widget.selectedMenuItem, itemCounter);

                      // Clear the quantity input field
                      itemQuantityToCartController.clear();

                      // Navigate back to Seller Menu List
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellerMenuList(
                                  selectedSellerInformation:
                                      widget.selectedSellerInformation)));
                    },
                    style: ElevatedButton.styleFrom(
                        // backgroundColor: Colors.white12,
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