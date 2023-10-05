import 'cartItem.dart';

class Carts {
  String? cartID;
  final String sellerID;
  final List<CartItem> cartItems;

  Carts({
    required this.sellerID,
    required this.cartItems,
  });

  Map<String, dynamic> toMap() {
    return {
      'sellerID': sellerID,
      'cartItems': cartItems.map((item) => item.toMap()).toList(),
    };
  }

  Carts.fromMap(Map<String, dynamic> map)
      : sellerID = map['sellerID'],
        cartItems = List<CartItem>.from(
            (map['cartItems'] as List).map((item) => CartItem.fromMap(item)));
}
