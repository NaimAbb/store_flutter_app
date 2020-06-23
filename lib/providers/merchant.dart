import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:store_flutter_app/db/db_helper.dart';
import 'package:store_flutter_app/models/category.dart';
import 'package:store_flutter_app/models/order_merchant.dart';
import 'package:store_flutter_app/models/product.dart';
import 'package:store_flutter_app/utils/constants.dart';
import 'package:path/path.dart';

class Merchant extends ChangeNotifier {
  DBHelper _db = new DBHelper();
  List<Category> _categories = [];
  List<OrderMerchant> _orders = [];
  bool _chooseImage = false;

  void changeValueChooseImage() {
    _chooseImage = true;
    notifyListeners();
  }

  void changeValueChooseImageToFalse() {
    _chooseImage = false;
  }

  List<Category> get categories {
    return [..._categories];
  }

  List<OrderMerchant> get getOrders => [..._orders];

  bool get valueChooseImage {
    return _chooseImage;
  }

  Future<void> getCategories() async {
    try {
      Firestore firestore = Firestore.instance;
      CollectionReference crCategories = firestore.collection('Category');
      QuerySnapshot querySnapshot = await crCategories.getDocuments();
      List<DocumentSnapshot> documentSnapshots = querySnapshot.documents;
      List<Category> categories = [];
      for (int i = 0; i < documentSnapshots.length; i++) {
        Category category = Category.fromJson(documentSnapshots[i].data);
        categories.add(category);
      }
      _categories = categories;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<StorageTaskSnapshot> uploadImage(
      {@required String fileName, @required File fileImage}) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask task = ref.putFile(fileImage);
    Future<StorageTaskSnapshot> taskSnapshot = task.onComplete;
    return taskSnapshot;
  }

  Future<void> addProduct(Product product, File fileImage) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = await auth.currentUser();
      StorageTaskSnapshot storageTaskSnapshot = await uploadImage(
          fileImage: fileImage, fileName: basename(fileImage.path));
      final imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
      Firestore firestore = Firestore.instance;
      CollectionReference crProduct = firestore.collection('Product');
      print(imageUrl);
      DocumentReference documentReference = await crProduct.add({
        'name': product.name,
        'price': product.price,
        'duscription': product.description,
        'image': imageUrl,
        'idCategory': product.idCategory
      });
      CollectionReference crProductUser = firestore.collection('ProductUser');
      await crProductUser.document().setData({
        'idUser': currentUser.uid,
        'idProduct': documentReference.documentID
      });

//      await _db.addProduct(
//          product, int.parse(Constants.sharedPreferencesLocal.getUserId()));
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> getOrdersForMerchant(String idMerchant) async {
    try {
      Map<String, OrderMerchant> data = {};

      Firestore firestore = Firestore.instance;
      CollectionReference crOrderDetails = firestore.collection('OrderDetails');
      CollectionReference crProduct = firestore.collection('Product');
      CollectionReference crOrderProduct = firestore.collection('OrderProduct');
      CollectionReference crUser = firestore.collection('User');
      CollectionReference crAddress = firestore.collection('Address');
      QuerySnapshot querySnapshot = await crOrderDetails
          .where('idMerchant', isEqualTo: idMerchant)
          .getDocuments();
      List<DocumentSnapshot> documentSnapshots = querySnapshot.documents;
      for (int i = 0; i < documentSnapshots.length; i++) {
        final idOrder = documentSnapshots[i].data['idOrder'] as String;
        if (data.containsKey(idOrder)) {
          DocumentSnapshot documentSnapshot =
              await crProduct.document(documentSnapshots[i].documentID).get();
          Product productData = Product.fromJson(documentSnapshot.data);
          final dataOrder = data[idOrder];
          dataOrder.products.add(productData);
          data[idOrder] = dataOrder;
        } else {
          QuerySnapshot querySnapshot = await crProduct
              .where(documentSnapshots[i].data['idProduct'])
              .getDocuments();
          List<DocumentSnapshot> documentSnapshotsTwo = querySnapshot.documents;
          Product productData = Product.fromJson(documentSnapshotsTwo[0].data);
          List<Product> allProducts = [productData];
          DocumentSnapshot documentSnapshotThree = await crOrderProduct
              .document(documentSnapshots[i].data['idOrder'])
              .get();
          DocumentSnapshot documentSnapshotFour = await crUser
              .document(documentSnapshotThree.data['idClient'])
              .get();
          DocumentSnapshot documentSnapshotFife = await crAddress
              .document(documentSnapshotThree.data['idAddress'])
              .get();
          final total = documentSnapshotThree.data['totlaPrice'] as double;
          data[idOrder] = new OrderMerchant(
              documentSnapshots[i].data['idOrder'].toString(),
              documentSnapshotFour.data['name'],
              documentSnapshotFife.data['name'],
              total.toDouble(),
              allProducts);
//          crProduct.document()
//          List<Map> product = await dbConnection.rawQuery(
//              'SELECT * FROM $tableProduct WHERE $columnId = ?',
//              [list[i][columnIdProductF]]);
//          Product productData = Product.fromJson(product[0]);
        }
      }
      //final orders = await _db.getOrdersForMerchant(idMerchant);
      _orders = data.values.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
