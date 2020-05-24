import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:store_flutter_app/models/user.dart';

class DBHelper {
  static final String tableUser = 'User';

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
  }

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
//  void onCreateTableClient(Database db, int version) async {
//    await db.execute(
//        'CREATE TABLE $tableNameClient (id TEXT PRIMARY KEY NOT NULL  , userName TEXT NOT NULL , age INTEGER NOT NULL , imageUrl TEXT NOT NULL , typeAccount INTEGER NOT NULL , email TEXT NOT NULL, phoneNumber TEXT NOT NULL , codeIntroduction TEXT NOT NULL  );');
//  }
//
//  void onCreateTableTechnician(Database db, int version) async {
//    await db.execute(
//        'CREATE TABLE $tableNameTechnician (id TEXT PRIMARY KEY NOT NULL  , userName TEXT NOT NULL , age INTEGER NOT NULL , imageUrl TEXT NOT NULL , typeAccount INTEGER NOT NULL , email TEXT NOT NULL, phoneNumber TEXT NOT NULL , codeIntroduction TEXT NOT NULL , fullTechnicianMaintenanceName TEXT NOT NULL , qualifications TEXT );');
//  }
//
//  void onCreateTableWorkshop(Database db, int version) async {
//    await db.execute(
//        'CREATE TABLE $tableNameWorkshop (id TEXT PRIMARY KEY NOT NULL , userName TEXT NOT NULL ,fullEngineerName TEXT NOT NULL ,  age INTEGER NOT NULL , imageUrl TEXT NOT NULL , typeAccount INTEGER NOT NULL , email TEXT NOT NULL, phoneNumber TEXT NOT NULL , codeIntroduction TEXT NOT NULL , latitude REAL NOT NULL , longitude REAL NOT NULL , address TEXT NOT NULL  );');
//  }

//   Future<List<String>> getString() async {
//    var dbConnection = await db;
//    List<Map> list = await dbConnection.rawQuery('SELECT * FROM $tableName');
//    List<String> str = new List();
//
//    for (int i = 0; i < list.length; i++) {
//      // obj
//
//      list[i]['id'];
//    }
//  }
//
//  void addNewRow(Object object) async {
//    var dbConnection = await db;
//    String query =
//        'INSERT INTO $tableName(name , ...) VALUES (\'${object}\' , \'${object}\')';
//    await dbConnection.transaction((transaction) async {
//      return await transaction.rawInsert(query);
//    });
//  }
//
//
//  void updateRow() async {
//    var dbConnection = await db;
//    String query = 'UPDATE $tableName SET id = \'${}\'  , ... , WHERE name = ${''}';
//    await dbConnection.transaction((transaction) async {
//      return await transaction.rawQuery(query);
//    });
//  }
//
//
//  void deleteRow() async {
//    var dbConnection = await db;
//    String query = 'DELETE FROM  WHERE name = ${''}';
//    await dbConnection.transaction((transaction) async {
//      return await transaction.rawQuery(query);
//    });
//  }

}
