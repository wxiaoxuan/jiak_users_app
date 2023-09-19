import 'package:mongo_dart/mongo_dart.dart';

import '../models/user.dart';
import 'constants.dart';

class MongoDB {
  static var db, userCollection, sellerCollection, menuCollection;

  // connect to db - User Collection
  static connect() async {
    db = await Db.create(MONGO_URL);
    await db.open(secure: true);
    userCollection = await db.collection(COLLECTION_NAME);
  }

  // Retrieve All User's Data - User Collection
  static Future<List<Map<String, dynamic>>> getUsersDocument() async {
    try {
      final users = await userCollection.find().toList();
      return users;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // connect to db - Seller Collection
  static connectSeller() async {
    db = await Db.create(MONGO_URL);
    await db.open(secure: true);
    sellerCollection = await db.collection(SELLER_COLLECTION_NAME);
  }

  // connect to db - Menu Collection
  static connectCollectionMenu() async {
    try {
      db = await Db.create(MONGO_URL);
      await db.open(secure: true);
      menuCollection = db.collection(COLLECTION_NAME_MENUS);
      // print("im in connectCollectionMenu function.");
      // print(menuCollection);
    } catch (e) {
      print('Error connecting to the menu collection. $e');
      rethrow;
    }
  }

  // Retrieve All Seller's Data - Seller Collection
  static Future<List<Map<String, dynamic>>> getSellersDocument() async {
    try {
      final users = await sellerCollection.find().toList();
      return users;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Retrieve All Menu's Data - Menu Collection
  static Future<List<Map<String, dynamic>>> getMenuDocuments() async {
    try {
      if (menuCollection == null) {
        // If menuCollection is null, connect to it first
        await connectCollectionMenu();
      }

      final menu = await menuCollection.find().toList();
      // print(menu);
      return menu;
    } catch (e) {
      print('Unable to retrieve list of menu. $e');
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
    // await userCollection.remove(where.id(user.id));
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
