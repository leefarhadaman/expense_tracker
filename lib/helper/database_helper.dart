import 'package:expense_tracker/model/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "ExpenseTracker.db";
  static final _databaseVersion = 1;

  static final table = 'expenses';
  static final columnId = 'id';
  static final columnCategory = 'category';
  static final columnAmount = 'amount';
  static final columnDate = 'date';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCategory TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
  }

  // Insert a new expense
  Future<int> insertExpense(Expense expense) async {
    Database db = await database;
    return await db.insert(table, expense.toMap());
  }

  // Get all expenses
  Future<List<Expense>> getAllExpenses() async {
    Database db = await database;
    var result = await db.query(table);
    return result.map((e) => Expense.fromMap(e)).toList();
  }

  // Get total expenses
  Future<double> getTotalExpenses() async {
    Database db = await database;
    var result = await db.rawQuery('SELECT SUM($columnAmount) FROM $table');
    return result.first.values.first as double;
  }

  // Update an expense
  Future<int> updateExpense(Expense expense) async {
    Database db = await database;
    return await db.update(
      table,
      expense.toMap(),
      where: '$columnId = ?',
      whereArgs: [expense.id],
    );
  }

  // Delete an expense
  Future<int> deleteExpense(int id) async {
    Database db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Delete all expenses
  Future<int> deleteAllExpenses() async {
    Database db = await database;
    return await db.delete(table);
  }
}
