// data/datasources/local/expense_local_datasource.dart
import 'package:hive/hive.dart';
import '../../models/expense_model.dart';

class ExpenseLocalDataSource {
  static const String _boxName = 'expenses';

  Future<void> addExpense(ExpenseModel expense) async {
    final box = await Hive.openBox<ExpenseModel>(_boxName);
    await box.add(expense);
  }

  Future<List<ExpenseModel>> getExpenses() async {
    final box = await Hive.openBox<ExpenseModel>(_boxName);
    return box.values.toList();
  }

  Future<void> updateExpense(int index, ExpenseModel expense) async {
    final box = await Hive.openBox<ExpenseModel>(_boxName);
    await box.putAt(index, expense);
  }

  Future<void> deleteExpense(int index) async {
    final box = await Hive.openBox<ExpenseModel>(_boxName);
    await box.deleteAt(index);
  }

  Future<List<ExpenseModel>> getExpensesByCategory(String category) async {
    final box = await Hive.openBox<ExpenseModel>(_boxName);
    return box.values.where((expense) => expense.category == category).toList();
  }

  Future<List<ExpenseModel>> getExpensesByDateRange(
      DateTime start,
      DateTime end,
      ) async {
    final box = await Hive.openBox<ExpenseModel>(_boxName);
    return box.values
        .where((expense) =>
    expense.date.isAfter(start) && expense.date.isBefore(end))
        .toList();
  }
}