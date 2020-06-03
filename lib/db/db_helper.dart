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
import 'package:store_flutter_app/models/order_merchant.dart';
import 'package:store_flutter_app/models/product.dart';
import 'package:store_flutter_app/models/user.dart';

class DBHelper {
  // shared argument

  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnImage = 'image';
  static const String columnIdUserF = 'idUser';
  static const String columnIdProductF = 'idProduct';
  static const String columnIdAddressF = 'idAddress';
  static const String columnQuantity = 'quantity';

  // start table user
  final String tableUser = 'User';
  static const String columnEmailUser = 'email';
  static const String columnPasswordUser = 'password';
  static const String columnTypeUser = 'type';

  // end table user

  // start table category
  final String tableCategory = 'Category';
  static const String columnImageUrlCategory = 'imageUrl';

  // end table category

  // start table product
  final String tableProduct = 'product';
  static const String columnDuscriptionProduct = 'duscription';
  static const String columnPriceProduct = 'price';
  static const String columnIdCategoryProduct = 'idCategory';

  // end table product

  // start table productUser
  final String tableProductUser = 'productUser';

  //end table productUser

  // start table cart
  final String tableCart = 'Cart';
  static const String columnNameProductCart = 'nameProduct';
  static const String columnTotalPriceCart = 'totalPrice';

  // end table cart

  // start table address
  final String tableAddress = 'Address';
  static const String columnAddressLaneAddress = 'addressLane';
  static const String columnCityAddress = 'city';
  static const String columnPostalCodeAddress = 'postalCode';
  static const String columnPhoneNumberAddress = 'phoneNumber';

  // end table address

  // start table OrderProduct
  final String tableOrderProduct = 'OrderProduct';
  static const String columnTotlaPriceOrderProduct = 'totlaPrice';
  static const String columnDescriptionOrderProduct = 'description';
  static const String columnIdClientOrderProduct = 'idClient';

  // end table OrderProduct

  // start table OrderDetails
  final String tableOrderDetails = 'OrderDetails';
  static const String columnIdOrderOrderDetails = 'idOrder';
  static const String columnIdMerchantOrderDetails = 'idMerchant';

  // end table OrderDetails

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
    //   var r = await databaseExists(path);
    var db = await openDatabase(path, version: 1, onCreate: onCreateAll);
    return db;
  }

  void onCreateAll(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableUser (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  ,
        $columnName TEXT NOT NULL , 
        $columnEmailUser TEXT NOT NULL , 
        $columnPasswordUser TEXT NOT NULL ,  
        $columnTypeUser TEXT NOT NULL 
        );
        ''');

    await db.execute('''
    CREATE TABLE $tableCategory (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 
        $columnName TEXT NOT NULL , 
        $columnImageUrlCategory TEXT NOT NULL
        );
        ''');

    await db.execute('''
    CREATE TABLE $tableProduct (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 
        $columnName TEXT NOT NULL ,
        $columnDuscriptionProduct TEXT NOT NULL, price REAL NOT NULL , 
        $columnImage TEXT NOT NULL,
        $columnIdCategoryProduct INTEGER NOT NULL , 
        FOREIGN KEY($columnIdCategoryProduct) REFERENCES $tableCategory ($columnId)
        );
        ''');

    await db.execute('''
        CREATE TABLE $tableProductUser (
        $columnIdUserF INTEGER NOT NULL  , 
        $columnIdProductF INTEGER NOT NULL ,
        FOREIGN KEY($columnIdUserF) REFERENCES $tableUser ($columnId)  , 
        FOREIGN KEY($columnIdProductF) REFERENCES $tableProduct ($columnId)
        );
        ''');

    await db.execute('''
        CREATE TABLE $tableCart (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        $columnIdProductF INTEGER NOT NULL , 
        $columnNameProductCart TEXT NOT NULL , 
        $columnImage TEXT NOT NULL ,
        $columnTotalPriceCart REAL NOT NULL ,
        $columnQuantity INTEGER NOT NULL,
        FOREIGN KEY($columnIdProductF) REFERENCES $tableProduct ($columnId)
        )
        ''');

    await db.execute('''
        CREATE TABLE $tableAddress (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 
        $columnIdUserF INTEGER NOT NULL , 
        $columnName TEXT NOT NULL ,
        $columnAddressLaneAddress TEXT NOT NULL , 
        $columnCityAddress TEXT NOT NULL , 
        $columnPostalCodeAddress TEXT NOT NULL , 
        $columnPhoneNumberAddress TEXT NOT NULL , 
        FOREIGN KEY($columnIdUserF) REFERENCES $tableUser ($columnId) 
        )
        ''');

    await db.execute('''
        CREATE TABLE $tableOrderProduct (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 
        $columnTotlaPriceOrderProduct REAR NOT NULL  , 
        $columnDescriptionOrderProduct TEXT , 
        $columnIdClientOrderProduct INTEGER NOT NULL ,
        $columnIdAddressF INTEGER NOT NULL,
        FOREIGN KEY($columnIdAddressF) REFERENCES $tableAddress ($columnId),  
        FOREIGN KEY($columnIdClientOrderProduct) REFERENCES $tableUser ($columnId)
        );
        ''');

    await db.execute('''
        CREATE TABLE $tableOrderDetails (
        $columnIdOrderOrderDetails INTEGER NOT NULL , 
        $columnIdProductF INTEGER NOT NULL , 
        $columnIdMerchantOrderDetails INTEGER NOT NULL , 
        $columnIdAddressF INTEGER NOT NULL ,
        $columnQuantity INTEGER NOT NULL  , 
        FOREIGN KEY($columnIdAddressF) REFERENCES $tableAddress ($columnId), 
        FOREIGN KEY($columnIdOrderOrderDetails) REFERENCES $tableOrderProduct ($columnId) , 
        FOREIGN KEY($columnIdProductF) REFERENCES $tableProduct ($columnId) ,  
        FOREIGN KEY($columnIdMerchantOrderDetails) REFERENCES $tableUser ($columnId)
        );
        ''');
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
    List<Map> list =
        await dbConnection.rawQuery('SELECT * FROM $tableCategory');

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
      Order order = new Order(
          listOrderProduct[i]['id'], total.toDouble(), listProduct[0]['image']);
      orders.add(order);
    }
    return orders;
  }

  Future<List<OrderMerchant>> getOrdersForMerchant(int idMerchant) async {
    var dbConnection = await db();
    Map<int, OrderMerchant> data = {};
    List<Map> list = await dbConnection.rawQuery(
        'SELECT * FROM $tableOrderDetails WHERE idMerchant = ?', [idMerchant]);
    for (int i = 0; i < list.length; i++) {
      final idOrder = list[i]['idOrder'] as int;
      if (data.containsKey(idOrder)) {
        List<Map> product = await dbConnection.rawQuery(
            'SELECT * FROM $tableProduct WHERE id = ?', [list[i]['idProdcut']]);

        Product productData = new Product(
            product[0]['name'],
            product[0]['price'],
            product[0]['idCategory'],
            product[0]['duscription']);
        productData.id = list[i]['idProdcut'].toString();
        productData.image = product[0]['image'];
        final dataOrder = data[idOrder];
        dataOrder.products.add(productData);
        data[idOrder] = dataOrder;
      } else {
        List<Map> product = await dbConnection.rawQuery(
            'SELECT * FROM $tableProduct WHERE id = ?', [list[i]['idProdcut']]);

        Product productData = new Product(
            product[0]['name'],
            product[0]['price'],
            product[0]['idCategory'],
            product[0]['duscription']);
        productData.id = list[i]['idProdcut'].toString();
        productData.image = product[0]['image'];

        List<Product> allProducts = [productData];
        List<Map> order = await dbConnection.rawQuery(
            'SELECT * FROM $tableOrderProduct WHERE id = ?',
            [list[i]['idOrder']]);

        List<Map> client = await dbConnection.rawQuery(
            'SELECT * FROM $tableUser WHERE id = ?', [order[0]['idClient']]);

        List<Map> address = await dbConnection.rawQuery(
            'SELECT * FROM $tableAddress WHERE id = ?',
            [order[0]['idAddress']]);
        final total = order[0]['totlaPrice'] as int;

        data[idOrder] = new OrderMerchant(
            list[i]['idOrder'].toString(),
            client[0]['name'],
            address[0]['name'],
            total.toDouble(),
            allProducts);
      }
    }

    data.values.toList().forEach((element) {
      element.products.forEach((elementT) {
        print(elementT.name);
      });
    });

    return data.values.toList();
  }

  Future<List<Product>> searchAboutProduct(String wordSearch) async {
    print(wordSearch);
    var dbConnection = await db();
    List<Map> products = await dbConnection.query(tableProduct,
        where: "name LIKE ? ", whereArgs: ['%$wordSearch%']);
    List<Product> productsData = [];
    for (int i = 0; i < products.length; i++) {
      Product product = Product.fromJson(products[i]);
      productsData.add(product);
    }
    return productsData;
  }
}
