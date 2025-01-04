import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  List<String> _categories = ['Food', 'Transport', 'Entertainment', 'Shopping'];

  List<Expense> get expenses => _expenses;
  List<String> get categories => _categories;

  Future<void> initDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'expenses.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT, amount REAL, category TEXT, date TEXT)',
        );
      },
      version: 1,
    );

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expenses');
    _expenses = List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        amount: maps[i]['amount'],
        category: maps[i]['category'],
        date: maps[i]['date'],
      );
    });

    notifyListeners();
  }

  Future<void> addExpense(double amount, String category, String date) async {
    final db = await openDatabase(join(await getDatabasesPath(), 'expenses.db'));
    final id = await db.insert(
      'expenses',
      {'amount': amount, 'category': category, 'date': date},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _expenses.add(Expense(id: id, amount: amount, category: category, date: date));
    notifyListeners();
  }

  Future<void> updateExpense(int id, double amount, String category, String date) async {
    final db = await openDatabase(join(await getDatabasesPath(), 'expenses.db'));
    await db.update(
      'expenses',
      {'amount': amount, 'category': category, 'date': date},
      where: 'id = ?',
      whereArgs: [id],
    );

    final index = _expenses.indexWhere((expense) => expense.id == id);
    _expenses[index] = Expense(id: id, amount: amount, category: category, date: date);
    notifyListeners();
  }

  Future<void> deleteExpense(int id) async {
    final db = await openDatabase(join(await getDatabasesPath(), 'expenses.db'));
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );

    _expenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }

  void addCategory(String category) {
    _categories.add(category);
    notifyListeners();
  }

  void removeCategory(String category) {
    _categories.remove(category);
    notifyListeners();
  }
}
