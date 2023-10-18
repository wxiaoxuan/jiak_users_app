import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  Map<String, int> cartItems = {};

  // Add Menu Item to Cart
  void addToCart(String menuItemID, int quantity) {
    if (cartItems.containsKey(menuItemID)) {
      // return 0 if cartItems[menuItemID] is empty
      cartItems[menuItemID] = (cartItems[menuItemID] ?? 0) + quantity;
    } else {
      cartItems[menuItemID] = quantity;
    }
    notifyListeners();
  }

  // Remove Menu Item from Cart
  void removeFromCart(String menuItemID) {
    cartItems.remove(menuItemID);
    notifyListeners();
  }

  // Get Total No. of Menu Items
  int getTotalItemCount() {
    int totalCount = 0;
    cartItems.forEach((_, quantity) {
      totalCount += quantity;
    });

    return totalCount;
  }
}
