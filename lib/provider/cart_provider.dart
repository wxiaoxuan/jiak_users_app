import 'package:flutter/material.dart';

import '../models/carts.dart';

class CartProvider extends ChangeNotifier {
  // =================List of Menu Items in Cart=========================
  List<Map<String, dynamic>> cartItems = [];
  Map<String, int> cartItemsQuantity = {};
  double totalCartPrice = 0.0;

  // List<Map<String, dynamic>> latestOrders = [];
  List<Carts> latestOrders = [];

  // Set the latest order
  void setLatestOrder(List<Carts> order) {
    print("Order data in provider: $order");
    latestOrders = order;
    notifyListeners();

    print(cartItems);
    print("===========================");
    print(latestOrders);
  }

  void clearLatestOrder() {
    latestOrders = [];
    notifyListeners();
  }

  void addToCart(Map<String, dynamic> seller, String menuItemID,
      Map<String, dynamic> menuItem, int quantity) {
    cartItems.add({
      'sellerID': seller['_id']?.toString() ?? "",
      'sellerName': seller['name'],
      'menuID': menuItem['_id']?.toString() ?? "",
      'menuTitle': menuItem['menuTitle'],
      'menuInformation': menuItem['menuInformation'],
      'menuPrice': menuItem['menuPrice'],
      'quantity': quantity,
    });
  }

  // ================ Count Menu Item Quantity in Cart=========================
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

  // ==================== Remove Menu Item from Cart ==========================
  void clearCart() {
    cartItems.clear();
    cartItemsQuantity.clear();
    totalCartPrice = 0.0;
    notifyListeners();
  }

  // ================= Get Total No. of Menu Items ============================
  int getTotalItemCount() {
    int totalCount = 0;
    cartItemsQuantity.forEach((_, quantity) {
      totalCount += quantity;
    });
    return totalCount;
  }

  // ================= Update Cart Item's Quantity ============================
  void updateCartItemQuantity(String menuItemID, int quantity) {
    // Find the index of the item in cartItems
    final int index =
        cartItems.indexWhere((item) => item['menuID'] == menuItemID);

    if (index != -1) {
      // Update the quantity
      cartItems[index]['quantity'] = quantity;

      calculateTotalPrice();
      notifyListeners();
    }
  }

  // ================= Calculate the Total Price of the Cart ==================
  double calculateTotalPrice() {
    return cartItems.fold(
      0.0,
      (total, item) => total + item['menuPrice'] * item['quantity'],
    );
  }

  // ======= Calculate the Menu Item's Total Price [Quantity * Price] =========
  double calculateTotalItemPrice(Map<String, dynamic> menuItem) {
    return menuItem['menuPrice'] * menuItem['quantity'];
  }

  // ================ Delete Menu Item in Cart Check Out Page =================
  void removeCartItem(String menuItemID) {
    cartItems.removeWhere((item) => item['menuID'] == menuItemID);
    // Remove the item from cartItemsQuantity if it exists
    cartItemsQuantity.remove(menuItemID);
    calculateTotalPrice();
    notifyListeners();
  }
}