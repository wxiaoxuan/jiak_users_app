// Information to retrieve from the Sellers
class Sellers {
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? location;
  Map<String, dynamic>? imageMetaData;

  Sellers(
      {this.uid,
      this.name,
      this.email,
      this.phone,
      this.location,
      this.imageMetaData});

  Sellers.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    location = json['location'];
    imageMetaData = json['imageMetaData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = uid;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['location'] = location;
    data['imageMetaData'] = imageMetaData;

    return data;
  }
}
