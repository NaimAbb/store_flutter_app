import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_flutter_app/db/db_helper.dart';
import 'package:store_flutter_app/models/modelsProvider/address.dart';
import 'package:store_flutter_app/models/modelsProvider/cart_item.dart';
import 'package:store_flutter_app/models/category.dart';
import 'package:store_flutter_app/models/order.dart';
import 'package:store_flutter_app/models/product.dart';

class Client extends ChangeNotifier {
  DBHelper _db = new DBHelper();
  List<Category> _categories = [];
  List<Product> _productFeatured = [];
  List<Product> _productByCategory = [];
  List<Product> _searchProduct = [];
  List<Product> _detailsOrderProducts = [];
  List<Address> _allAddress = [];
  List<CartItem> _carts = [];
  List<Order> _orders = [];

  int _totalItemInCart = 0;

  int get totalItemInCart => _totalItemInCart;

  List<Product> get getFeatured => [..._productFeatured];

  List<Product> get getDetailsOrderProducts => [..._detailsOrderProducts];

  List<Product> get productCategory => [..._productByCategory];

  List<Product> get productSearch => [..._searchProduct];

  List<Address> get getAllAddress => [..._allAddress];

  List<Category> get categories => [..._categories];

  List<CartItem> get carts => [..._carts];

  List<Order> get getOrders => [..._orders];

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

  Future<void> getProductFeatured() async {
    try {
      Firestore firestore = Firestore.instance;
      CollectionReference crProduct = firestore.collection('Product');
      QuerySnapshot querySnapshot = await crProduct.limit(10).getDocuments();
      List<DocumentSnapshot> documentSnapshots = querySnapshot.documents;
      List<Product> products = [];
      for (int i = 0; i < documentSnapshots.length; i++) {
        Product product = Product.fromJson(documentSnapshots[i].data,
            id: documentSnapshots[i].documentID);
        products.add(product);
      }

      //   final productFeatured = await _db.getProductFeatured();
      _productFeatured = products;
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> productByCategory(String idCategory) async {
    try {
      notifyListeners();

      Firestore firestore = Firestore.instance;
      CollectionReference crProduct = firestore.collection('Product');
      QuerySnapshot querySnapshot = await crProduct
          .where('idCategory', isEqualTo: idCategory)
          .getDocuments();
      List<DocumentSnapshot> documentSnapshots = querySnapshot.documents;
      List<Product> products = [];
      for (int i = 0; i < documentSnapshots.length; i++) {
        Product product = Product.fromJson(documentSnapshots[i].data);
        products.add(product);
      }

      //    final products = await _db.productsByCategory(idCategory);
      _productByCategory = products;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addToCart(CartItem cartItem) async {
    try {
      await _db.addToCard(cartItem);
    } catch (error) {
      throw error;
    }
  }

  Future<void> reducingTheQuantity(String idProduct) async {
    try {
      await _db.reducingTheQuantity(idProduct);
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteItemFromCart(String idProduct) async {
    try {
      await _db.deleteItemFromCart(idProduct);
      await getAllItemsFromCart();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getAllItemsFromCart() async {
    try {
      final carts = await _db.getCarts();
      _carts = carts;
      notifyListeners();
    } catch (error) {}
  }

  Future<void> getCount() async {
    int total = 0;
    final carts = await _db.getCarts();
    for (var item in carts) {
      total += item.quantity;
    }
    _totalItemInCart = total;
    notifyListeners();
  }

  Future<void> addAddress(Address address) async {
    try {
      Firestore firestore = Firestore.instance;
      CollectionReference crAddress = firestore.collection('Address');
      DocumentReference documentReference = await crAddress.add({
        'idUser': address.idUser,
        'name': address.name,
        'addressLane': address.addressLane,
        'city': address.city,
        'postalCode': address.postalCode,
        'phoneNumber': address.phoneNumber
      });
      // final id = await _db.addAddress(address);
      address.id = documentReference.documentID;
      _allAddress.add(address);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getAllAddressForUser(String idUser) async {
    try {
      Firestore firestore = Firestore.instance;
      CollectionReference crAddress = firestore.collection('Address');
      QuerySnapshot querySnapshot =
          await crAddress.where('idUser', isEqualTo: idUser).getDocuments();
      List<DocumentSnapshot> documentSnapshots = querySnapshot.documents;
      List<Address> addressAll = [];
      for (int i = 0; i < documentSnapshots.length; i++) {
        Address address = Address.formJson(documentSnapshots[i].data,
            idAddress: documentSnapshots[i].documentID);
        addressAll.add(address);
      }
      //final address = await _db.getAddressForUser(idUser);
      _allAddress = addressAll;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(String idClient, String idAddress) async {
    try {
      Firestore firestore = Firestore.instance;
      CollectionReference crOrderProduct = firestore.collection('OrderProduct');
      double totalPrice = 0;
      _carts.forEach((element) {
        double totalItem = element.totalPrice * element.quantity;
        totalPrice += totalItem;
      });
      DocumentReference documentReference = await crOrderProduct.add({
        'totlaPrice': totalPrice,
        'description': '',
        'idClient': idClient,
        'idAddress': idAddress
      });

      CollectionReference crProductUser = firestore.collection('ProductUser');
      CollectionReference crOrderDetails = firestore.collection('OrderDetails');

      for (var item in _carts) {
        String idProduct = item.idProdcut;
        QuerySnapshot querySnapshot = await crProductUser
            .where('idProduct', isEqualTo: idProduct)
            .getDocuments();
        final idMerchant = querySnapshot.documents[0].data['idUser'] as String;
        await crOrderDetails.document().setData({
          'idOrder': documentReference.documentID,
          'idMerchant': idMerchant,
          'idProduct': item.idProdcut,
          'quantity': item.quantity,
          'idAddress': idAddress
        });
      }

      // await _db.addOrder(_carts, idClient, idAddress);
      _carts.forEach((element) async {
        await deleteItemFromCart(element.idProdcut);
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> getOrdersForClient(String idClient) async {
    try {
      List<Order> orders = [];
      Firestore firestore = Firestore.instance;
      CollectionReference crOrderProduct = firestore.collection('OrderProduct');
      CollectionReference crOrderDetails = firestore.collection('OrderDetails');
      CollectionReference crProduct = firestore.collection('Product');
      QuerySnapshot querySnapshot = await crOrderProduct
          .where('idClient', isEqualTo: idClient)
          .getDocuments();
      List<DocumentSnapshot> documentSnapshots = querySnapshot.documents;

      for (int i = 0; i < documentSnapshots.length; i++) {
        QuerySnapshot querySnapshotTwo = await crOrderDetails
            .where('idOrder', isEqualTo: documentSnapshots[i].documentID)
            .limit(1)
            .getDocuments();
        DocumentSnapshot documentSnapshotTwo = await crProduct
            .document(querySnapshotTwo.documents[0].data['idProduct'])
            .get();
        final total = documentSnapshots[i].data['totlaPrice'] as double;
        Order order = new Order(documentSnapshots[i].documentID,
            total.toDouble(), documentSnapshotTwo.data['image']);
        orders.add(order);
      }

      //final orders = await _db.getOrdersForClient(idClient);
      _orders = orders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> searchAboutProduct(String wordSearch) async {
    try {
      final products = await _db.searchAboutProduct(wordSearch);
      _searchProduct = products;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void allProduct() {
    _productByCategory.clear();
    _searchProduct.clear();
    notifyListeners();
  }

  Future<void> getDetailsForOrder(String idOrder) async {
    try {
      List<Product> allProducts = [];

      Firestore firestore = Firestore.instance;
      CollectionReference crOrderDetails = firestore.collection('OrderDetails');
      CollectionReference crProduct = firestore.collection('Product');
      QuerySnapshot querySnapshot = await crOrderDetails
          .where('idOrder', isEqualTo: idOrder)
          .getDocuments();
      List<DocumentSnapshot> documentSnapshots = querySnapshot.documents;

      for (int i = 0; i < documentSnapshots.length; i++) {
        final idProduct = documentSnapshots[i].data['idProduct'] as String;
        DocumentSnapshot documentSnapshotTwo =
            await crProduct.document(idProduct).get();
        Product product = Product.fromJson(documentSnapshotTwo.data[0]);
        allProducts.add(product);
      }

      //final products = await _db.getOrdersDetailsForClient(idOrder);
      _detailsOrderProducts = allProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
