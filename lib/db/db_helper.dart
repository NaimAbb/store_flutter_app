import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:store_flutter_app/models/modelsProvider/address.dart';
import 'package:store_flutter_app/models/cart_item.dart';
import 'package:store_flutter_app/models/category.dart';
import 'package:store_flutter_app/models/order.dart';
import 'package:store_flutter_app/models/product.dart';
import 'package:store_flutter_app/models/user.dart';

class DBHelper {
  final String tableUser = 'User';
  final String tableCategory = 'Category';
  final String tableProduct = 'product';
  final String tableProductUser = 'productUser';
  final String tableCart = 'Cart';
  final String tableAddress = 'Address';
  final String tableOrderProduct = 'OrderProduct';
  final String tableOrderDetails = 'OrderDetails';

  static Database dbInstance;

  Future<Database> db() async {
    if (dbInstance == null) {
      dbInstance = await initDB();
    }
    return dbInstance;
  }

  initDB() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'StoreDB.db');
    var r = await databaseExists(path);
    var db = await openDatabase(path, version: 1, onCreate: onCreateAll);
    return db;
  }

  void onCreateAll(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tableUser (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  , name TEXT NOT NULL , email TEXT NOT NULL , password TEXT NOT NULL ,  type TEXT NOT NULL );');
    await db.execute(
        'CREATE TABLE $tableCategory (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , name TEXT NOT NULL , imageUrl TEXT NOT NULL);');

    await db.execute(
        'CREATE TABLE $tableProduct (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , name TEXT NOT NULL ,duscription TEXT NOT NULL, price REAL NOT NULL , image TEXT NOT NULL,idCategory INTEGER NOT NULL , FOREIGN KEY(idCategory) REFERENCES $tableCategory (id));');

    await db.execute(
        'CREATE TABLE $tableProductUser (idUser INTEGER NOT NULL  , idProduct INTEGER NOT NULL ,FOREIGN KEY(idUser) REFERENCES $tableUser (id)  , FOREIGN KEY(idProduct) REFERENCES $tableProduct (id));');

    await db.execute(
        'CREATE TABLE $tableCart (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, idProdcut INTEGER NOT NULL , nameProduct TEXT NOT NULL , image TEXT NOT NULL ,totalPrice REAL NOT NULL ,quantity INTEGER NOT NULL,FOREIGN KEY(idProdcut) REFERENCES $tableProduct (id) )');

    await db.execute(
        'CREATE TABLE $tableAddress (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , idUser INTEGER NOT NULL , name TEXT NOT NULL ,addressLane TEXT NOT NULL , city TEXT NOT NULL , postalCode TEXT NOT NULL , phoneNumber TEXT NOT NULL , FOREIGN KEY(idUser) REFERENCES $tableUser (id) )');

    await db.execute(
        'CREATE TABLE $tableOrderProduct (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , totlaPrice REAR NOT NULL  , description TEXT , idClient INTEGER NOT NULL ,idAddress INTEGER NOT NULL,FOREIGN KEY(idAddress) REFERENCES $tableAddress (id),  FOREIGN KEY(idClient) REFERENCES $tableUser (id));');

    await db.execute(
        'CREATE TABLE $tableOrderDetails (idOrder INTEGER NOT NULL , idProdcut INTEGER NOT NULL , idMerchant INTEGER NOT NULL , idAddress INTEGER NOT NULL ,quantity INTEGER NOT NULL  , FOREIGN KEY(idAddress) REFERENCES $tableAddress (id), FOREIGN KEY(idOrder) REFERENCES $tableOrderProduct (id) , FOREIGN KEY(idProdcut) REFERENCES $tableProduct (id) ,  FOREIGN KEY(idMerchant) REFERENCES $tableUser (id));');
  }

  // || Operation User

  Future<int> addUser(User user, String password) async {
    var dbConnection = await db();
    String type = '';
    if (user.type == Type.Client) {
      type = 'Client';
    } else {
      type = 'Merchant';
    }
    String query =
        'INSERT INTO $tableUser(name , email , password , type ) VALUES (\'${user.name}\' , \'${user.email}\' , \'${password}\' , \'${type}\')';
    int result = await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(query);
    });
    return result;
  }

  Future<List<User>> getUsers() async {
    var dbConnection = await db();
    List<Map> list = await dbConnection.rawQuery('SELECT * FROM $tableUser');
    List<User> users = new List();

    for (int i = 0; i < list.length; i++) {
      String type = list[i]['type'] as String;
      User user = new User(list[i]['name'], list[i]['email'],
          type == 'Client' ? Type.Client : Type.Merchant);
      user.id = list[i]['id'].toString();
      users.add(user);
    }
    return users;
  }

  Future<bool> searchAboutEmail(String email) async {
    var dbConnection = await db();
    List<Map> list = await dbConnection
        .rawQuery('SELECT * FROM $tableUser WHERE email = ?', [email]);
    if (list != null && list.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<User> emailAndPasswordIsExist(String email, String password) async {
    var dbConnection = await db();
    List<Map> list = await dbConnection.rawQuery(
        'SELECT * FROM $tableUser WHERE email = ? AND password = ?',
        [email, password]);
    if (list != null && list.isNotEmpty) {
      String type = list[0]['type'] as String;
      User user = new User(list[0]['name'], list[0]['email'],
          type == 'Client' ? Type.Client : Type.Merchant);
      user.id = list[0]['id'].toString();
      return user;
    } else {
      return null;
    }
  }

  Future<void> addCategories() async {
    var dbConnection = await db();

    List<Map<String, String>> categories = [
      {
        'title': 'Womman',
        'imageUrl':
            'https://i.pinimg.com/originals/8b/41/8b/8b418bcaa7d54f0ce0e5ca055bbe5a09.jpg'
      },
      {
        'title': 'Man',
        'imageUrl':
            'https://rafettna.xyz/wp-content/uploads/2018/10/print-t-shirt-blue.jpg'
      },
      {
        'title': 'Kids',
        'imageUrl':
            'https://i.pinimg.com/originals/06/64/81/06648122aa596e282a951408589c6d01.jpg'
      }
    ];
    //  List<String> categories = ['Womman', 'Man', 'Kids'];
    List<Map> list = await dbConnection.rawQuery('SELECT * FROM $tableCategory');

    if (list != null && list.isNotEmpty) return;
    for (Map<String, String> item in categories) {
      print(item);
      String query =
          'INSERT INTO $tableCategory (name , imageUrl) VALUES (\'${item['title']}\' , \'${item['imageUrl']}\')';
      int result = await dbConnection.transaction((transaction) async {
        return await transaction.rawInsert(query);
      });
    }
  }

  Future<List<Category>> getCategories() async {
    var dbConnection = await db();
    List<Map> list =
        await dbConnection.rawQuery('SELECT * FROM $tableCategory');
    List<Category> categories = new List();

    for (int i = 0; i < list.length; i++) {
      Category category = Category.fromJson(list[i]);

      categories.add(category);
    }
    return categories;
  }

  Future<void> addProduct(Product product, int idCurrentUser) async {
    var dbConnection = await db();
    String query =
        'INSERT INTO $tableProduct (name , duscription , price , image ,idCategory ) VALUES (\'${product.name}\', \'${product.description}\',${product.price} , \'${product.image}\' , ${product.idCategory})';

    int result = await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(query);
    });

    String queryTableProductUser =
        'INSERT INTO $tableProductUser (idUser ,idProduct ) VALUES (${idCurrentUser} , ${result})';
    int resultTableProductUser =
        await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(queryTableProductUser);
    });
  }

  Future<List<Product>> getProducts() async {
    var dbConnection = await db();
    List<Map> list = await dbConnection.rawQuery('SELECT * FROM $tableProduct');
    List<Product> products = new List();

    for (int i = 0; i < list.length; i++) {
      Product product = new Product(list[i]['name'], list[i]['price'],
          list[i]['idCategory'], list[i]['duscription']);
      product.image = list[i]['image'];
      product.id = list[i]['id'].toString();
      print(product.idCategory);
      products.add(product);
    }
    return products;
  }

  Future<List<Product>> getProductFeatured() async {
    var dbConnection = await db();
    List<Map> list =
        await dbConnection.rawQuery('SELECT * FROM $tableProduct LIMIT 10');
    List<Product> products = new List();

    for (int i = 0; i < list.length; i++) {
      Product product = new Product(list[i]['name'], list[i]['price'],
          list[i]['idCategory'], list[i]['duscription']);
      product.image = list[i]['image'];
      product.id = list[i]['id'].toString();
      print(product.idCategory);
      products.add(product);
    }
    return products;
  }

  Future<List<Product>> productsByCategory(int idCategory) async {
    var dbConnection = await db();
    List<Map> list = await dbConnection.rawQuery(
        'SELECT * FROM $tableProduct WHERE idCategory = ? ', [idCategory]);
    List<Product> products = new List();
    for (int i = 0; i < list.length; i++) {
      Product product = new Product(list[i]['name'], list[i]['price'],
          list[i]['idCategory'], list[i]['duscription']);
      product.image = list[i]['image'];
      product.id = list[i]['id'].toString();
      print(product.idCategory);
      products.add(product);
    }
    return products;
  }

  Future<void> addToCard(CartItem cartItem) async {
    var dbConnection = await db();
    List<Map> list = await dbConnection.rawQuery(
        'SELECT * FROM $tableCart WHERE idProdcut = ? ', [cartItem.idProdcut]);
    if (list != null && list.isNotEmpty) {
      var quantity = list[0]['quantity'] as int;
      quantity = quantity + 1;
      String query =
          'UPDATE $tableCart SET quantity = ${quantity} WHERE idProdcut = ${cartItem.idProdcut}';
      await dbConnection.transaction((transaction) async {
        return await transaction.rawQuery(query);
      });
    } else {
      String query =
          'INSERT INTO $tableCart (nameProduct , image ,totalPrice ,quantity , idProdcut) VALUES (\'${cartItem.nameProduct}\', \'${cartItem.image}\',${cartItem.totalPrice} , \'${cartItem.quantity}\',${cartItem.idProdcut})';

      int result = await dbConnection.transaction((transaction) async {
        return await transaction.rawInsert(query);
      });
    }
  }

  Future<List<CartItem>> getCarts() async {
    var dbConnection = await db();
    List<Map> list = await dbConnection.rawQuery('SELECT * FROM $tableCart');
    List<CartItem> cartItems = new List();

    for (int i = 0; i < list.length; i++) {
      print(list[i].toString());
      print(list[i]['quantity']);
      CartItem cartItem = new CartItem(list[i]['nameProduct'], list[i]['image'],
          list[i]['totalPrice'], list[i]['quantity'], list[i]['idProdcut']);
      cartItem.id = list[i]['id'].toString();
      cartItems.add(cartItem);
    }
    return cartItems;
  }

  Future<void> reducingTheQuantity(int idProduct) async {
    var dbConnection = await db();
    List<Map> list = await dbConnection
        .rawQuery('SELECT * FROM $tableCart WHERE idProdcut = ? ', [idProduct]);
    if (list != null && list.isNotEmpty) {
      var quantity = list[0]['quantity'] as int;
      quantity = quantity - 1;
      String query =
          'UPDATE $tableCart SET quantity = ${quantity} WHERE idProdcut = ${idProduct}';
      await dbConnection.transaction((transaction) async {
        return await transaction.rawQuery(query);
      });
    }
  }

  Future<void> deleteItemFromCart(int idProduct) async {
    var dbConnection = await db();
    String query = 'DELETE FROM $tableCart  WHERE idProdcut = ${idProduct}';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
  }

  Future<int> addAddress(Address address) async {
    var dbConnection = await db();
    String query =
        'INSERT INTO $tableAddress (idUser , name ,addressLane ,city , postalCode , phoneNumber) VALUES (${address.idUser}, \'${address.name}\',\'${address.addressLane}\', \'${address.city}\',\'${address.postalCode}\' , \'${address.phoneNumber}\')';

    int id = await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(query);
    });
    return id;
  }

  Future<List<Address>> getAddressForUser(int idUser) async {
    List<Address> addressAll = [];
    var dbConnection = await db();
    List<Map> list = await dbConnection
        .rawQuery('SELECT * FROM $tableAddress WHERE idUser = ? ', [idUser]);
    for (var address in list) {
      Address addressUser = Address.formJson(address);
      addressAll.add(addressUser);
    }
    return addressAll;
  }

  Future<void> addOrder(
      List<CartItem> items, int idClient, int idAddress) async {
    var dbConnection = await db();
    double totalPrice = 0;
    items.forEach((element) {
      double totalItem = element.totalPrice * element.quantity;
      totalPrice += totalItem;
    });
    String query =
        'INSERT INTO $tableOrderProduct (totlaPrice , description , idClient , idAddress) VALUES (${totalPrice} , \'${''}\' , ${idClient} , ${idAddress})';
    int idOrder = await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(query);
    });
    for (var item in items) {
      int idProduct = item.idProdcut;
      List<Map> list = await dbConnection.rawQuery(
          'SELECT idUser FROM $tableProductUser WHERE idProduct = ? ',
          [idProduct]);
      final idMerchant = list[0]['idUser'] as int;
      String queryDetailsOrder =
          'INSERT INTO $tableOrderDetails (idOrder , idProdcut , idMerchant , quantity , idAddress) VALUES (${idOrder} , ${item.idProdcut} , ${idMerchant} , ${item.quantity} , ${idAddress})';
      int idOrderDetails = await dbConnection.transaction((transaction) async {
        return await transaction.rawInsert(queryDetailsOrder);
      });
    }
  }

  Future<List<Order>> getOrdersForClient(int idClient) async {
    var dbConnection = await db();
    List<Order> orders = [];
    List<Map> listOrderProduct = await dbConnection.rawQuery(
        'SELECT * FROM $tableOrderProduct WHERE idClient = ? ', [idClient]);

    for (int i = 0; i < listOrderProduct.length; i++) {
      List<Map> listOrderDetails = await dbConnection.rawQuery(
          'SELECT * FROM $tableOrderDetails WHERE idOrder = ? LIMIT 1 ',
          [listOrderProduct[i]['id']]);
      List<Map> listProduct = await dbConnection.rawQuery(
          'SELECT * FROM $tableProduct WHERE id = ? ',
          [listOrderDetails[0]['idProdcut']]);
      final total = listOrderProduct[i]['totlaPrice'] as int;
      Order order =
      new Order(listOrderProduct[i]['id'], total.toDouble(), listProduct[0]['image']);
      orders.add(order);
    }
    return orders;
  }

}
