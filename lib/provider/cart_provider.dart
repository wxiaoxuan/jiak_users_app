import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
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
