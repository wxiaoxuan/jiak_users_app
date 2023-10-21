import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  // =================List of Menu Items in Cart=========================
  List<Map<String, dynamic>> cartItems = [];
  void addToCart(
      String menuItemID, Map<String, dynamic> menuItem, int quantity) {
    cartItems.add({
      'menuID': menuItem['_id']?.toString() ?? "",
      'menuTitle': menuItem['menuTitle'],
      'menuInformation': menuItem['menuInformation'],
      'menuPrice': menuItem['menuPrice'],
      'quantity': quantity,
    });

    print("cartItems");
    print(cartItems);
  }

  // =================Count Menu Item Quantity in Cart=========================
  Map<String, int> cartItemsQuantity = {};

  // Count Menu Item Quantity in Cart
  void addToCartQuantity(String menuItemID, int quantity) {
    if (cartItemsQuantity.containsKey(menuItemID)) {
      // return 0 if cartItems[menuItemID] is empty
      cartItemsQuantity[menuItemID] =
          (cartItemsQuantity[menuItemID] ?? 0) + quantity;
    } else {
      cartItemsQuantity[menuItemID] = quantity;
    }
    notifyListeners();
  }

  // Remove Menu Item from Cart
  void removeFromCart(String menuItemID) {
    cartItemsQuantity.remove(menuItemID);
    notifyListeners();
  }

  // Get Total No. of Menu Items
  int getTotalItemCount() {
    int totalCount = 0;
    cartItemsQuantity.forEach((_, quantity) {
      totalCount += quantity;
    });

    return totalCount;
  }
}
