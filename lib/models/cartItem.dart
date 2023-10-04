class CartItem {
  String? cartID;
  final String menuItemID;
  final String menuItemName;
  final double menuItemPrice;
  final int menuItemQuantity;

  CartItem({
    required this.menuItemID,
    required this.menuItemName,
    required this.menuItemPrice,
    required this.menuItemQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'menuItemID': menuItemID,
      'menuItemName': menuItemName,
      'menuItemPrice': menuItemPrice,
      'menuItemQuantity': menuItemQuantity,
    };
  }

  CartItem.fromMap(Map<String, dynamic> map)
      : menuItemID = map['menuItemID'],
        menuItemName = map['menuItemName'],
        menuItemPrice = map['menuItemPrice'],
        menuItemQuantity = map['menuItemQuantity'];
}

// -- Cart Details --
// Seller Name, Seller ID, Seller Email, Seller Location, Seller Image
// Menu ID, Menu Item, Menu Price, Quantity
