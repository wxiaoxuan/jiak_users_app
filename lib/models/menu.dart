// Information to retrieve menu from the Sellers
class Menu {
  String? menuID;
  final String menuTitle;
  final String menuInformation;
  final String menuStatus;
  final double menuPrice;
  final String sellerID;
  final Map<String, Object?> image;

  Menu({
    required this.menuTitle,
    required this.menuInformation,
    required this.menuStatus,
    required this.menuPrice,
    required this.sellerID,
    required Map<String, Object?>? image,
  }) : image = image ?? {};

  Map<String, dynamic> toMap() {
    return {
      'menuTitle': menuTitle,
      'menuInformation': menuInformation,
      'menuStatus': menuStatus,
      'menuPrice': menuPrice,
      'sellerID': sellerID,
      'image': image,
    };
  }

  Menu.fromMap(Map<String, dynamic> map)
      : menuID = map['menuID'],
        menuTitle = map['menuTitle'],
        menuInformation = map['menuInformation'],
        menuStatus = map['menuStatus'],
        menuPrice = map['menuPrice'],
        sellerID = map['sellerID'],
        image = map['image'];
}
