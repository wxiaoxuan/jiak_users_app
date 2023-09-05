class User {
  String? id;
  final String name;
  final String email;
  final String password;
  final int phone;
  final String location;
  // final List<int>? image; // optional

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.location,
    // this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'location': location,
      // if (image != null) 'image': image,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        name = map['name'],
        email = map['email'],
        password = map['password'],
        phone = map['phone'],
        location = map['location'];
  // image = map['image'] as List<int>?; // Handle null value here
}
