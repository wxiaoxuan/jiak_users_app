import 'package:mongo_dart/mongo_dart.dart';

import '../user.dart';
import 'constants.dart';

class MongoDB {
  static var db, userCollection;

  // connect to db
  static connect() async {
    db = await Db.create(MONGO_URL);
    await db.open(secure: true);
    userCollection = db.collection(COLLECTION_NAME);
    print(db);
    print(userCollection);
    print("==============================");
  }

  static Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      final users = await userCollection.find().toList();
      return users;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static insert(User user) async {
    print(user.toMap());
    userCollection = db.collection(COLLECTION_NAME);
    await userCollection.insert(user.toMap());
  }

  static update(User user) async {
    var user1 = await userCollection.findOne({"id": user.id});
    user1['name'] = user.name;
    user1['email'] = user.email;
    user1['password'] = user.password;
    user1['location'] = user.location;
    user1['phone'] = user.phone;
    await userCollection.save(user1);
  }

  static delete(User user) async {
    // await userCollection.remove(where.name(user.nameController.text));
  }
}

// Mongo Basic Usage
// https://pub.dev/packages/mongo_dart

// Create One Document in DB
// await collection
//     .insertOne({"name": "Glade Gel", "email": "glade@gmail.com"});

// Create Many Document in DB
// await collection.insertMany([
//   {"name": "Glade Gel", "email": "glade@gmail.com"},
//   {"name": "Dino No", "email": "dino@gmail.com"},
// ]);

// Update Existing Document in DB (eg. Name: Glade Gel to glade)
// await collection.update(
//     where.eq('name', 'Glade Gel'), modify.set('name', 'glade'));

// Update Many Existing Document in DB (eg. Name: Glade Gel to glade)
// await collection.updateMany( where.eq('name', 'Glade Gel'), modify.set('name', 'glade'));

// Delete One Document
// await collection.deleteOne({"username": "glade"});

// Delete Many Document relating to 'glade'
// await collection.deleteMany({"username": "glade"});

// print("============================================================");
// print(await collection.find().toList());
// print("============================================================");
