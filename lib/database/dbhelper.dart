import 'package:sqflite/sqflite.dart' as sql;

import '../models/todo_model.dart';

class DataBaseHelper {
  static DataBaseHelper? _dataBaseHelper;

  DataBaseHelper._instance();

  static DataBaseHelper get getDatabaseHelper {
    _dataBaseHelper ??= DataBaseHelper._instance();
    return _dataBaseHelper!;
  }

  String tableName = 'ToDo';
  String colId = 'ID';
  String colTitle = 'Title';
  String colDescription = 'Desc';
  String colPriorities = 'Priorities';
  String colCreatedAt = 'Created At';

  /// Todo 3 Creating getter for Database
  sql.Database? _database;

  String _databaseName = "Dummy";

  set setDataBaseName(String name) {
    _databaseName = name;
  }

  ///Todo 1 Initialize the database

  Future<sql.Database> initializeDatabase() async {
    /// Add on Info ->  if u want db at particular storage path use path provider and replace dbName param
    sql.Database db = await sql.openDatabase(
      _databaseName,

      /// 1-> This will create one db with no tables in it
      version: 1,

      /// 2 ->  If u to create table follow belongs
      onCreate: creatingTableWithDB,
    );
    return db;
  }

  void deleteDB() async {
    /// Add on Info -> Accidently created db will be removed
    bool status = await sql.databaseExists(_databaseName);
    if (status == true) {
      sql.deleteDatabase(_databaseName);
    }
  }

  /// Todo 2 Creating db
  Future<void> creatingTableWithDB(sql.Database db, int version) async {
    /// 3 -> u need execute the db and create a table
    await db.execute(
        'CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT , $colTitle TEXT NOT NULL, $colDescription TEXT, $colPriorities INTEGER ,$colCreatedAt TEXT)');

    /// 4 -> after this open inspector in android studio then choose the current emulator or simulator and see db with tables visually
  }

  /// Todo 4 Creating getter for Database since our db is private
  Future<sql.Database> get getDatabase async {
    /// by this we wont initialize db it will only create one time
    /// it is singleton database
    _database ??= await initializeDatabase();
    return _database!;
  }

/// DB CLos function
  Future close() async {
    final db = await getDatabase;
    db.close();
  }
  ///above this are the basic config for db setup--------------------------------------------

  /// Todo 5 Now we create a CRUD function seperately

  // Fetch Operation -> to get all objects from Database
  Future<List<TodoModel>> getDBItems() async {
    sql.Database db =
        await getDatabase; // we gonna use this getter to because _database can cause null error
    // now we can perform operation which is common for below methods

    // var result = db.rawQuery("SELECT * FROM $tableName order by $colId ASC"); u can use this Or
    var result = await db.query(tableName, orderBy: '$colId ASC');
    return result.map((e) => TodoModel.fromJson(e)).toList();
  }

  // Insert Operation -> to insert a new data into database
  Future<int> insertDataBase(TodoModel model) async {
    sql.Database db = await getDatabase;
    int id = await db.insert(tableName, model.toJson());
    return id;
  }

  // Update Operation -> to update a specific data or whole dta in database
  Future<int> updateDataBase(TodoModel model) async {
    sql.Database db = await getDatabase;
    int id = await db.update(tableName, model.toJson(),
        where: '$colId = ?', whereArgs: [model.id]);
    return id;
  }

  // Delete Operation -> to delete a thing in database
  Future<int> deleteDataBase(int deletId) async {
    sql.Database db = await getDatabase;
    int id =
        await db.rawDelete('DELETE FROM $tableName WHERE $colId = $deletId');
    return id;
  }

  // Get No of objects in Databse
  Future<int?> getCount() async {
    sql.Database db = await getDatabase;
    List<Map<String, Object?>> x =
        await db.rawQuery('SELECT COUNT (*) from $tableName');
    int? res = await sql.Sqflite.firstIntValue(x);
    return res;
  }

  /// PersonalUse

  Future<List<TodoModel>> getDBItemsBasedOnPriorities(
      int num) async {
    sql.Database db =
        await getDatabase; // we gonna use this getter to because _database can cause null error
    // now we can perform operation which is common for below methods

    // var result = db.rawQuery("SELECT * FROM $tableName order by $colId ASC"); u can use this Or
/*    var result =
        await db.query(tableName, where: '$colPriorities = ${num.toString()}');*/
    /*return result;*/
    var result = await db.query(tableName, where: '$colPriorities = ${num.toString()}');
    return result.map((e) => TodoModel.fromJson(e)).toList();
  }
}
