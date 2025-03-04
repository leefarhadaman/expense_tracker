import '../../data/models/expense_model.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(ExpenseModel expense);
  Future<List<ExpenseModel>> getExpenses();
  Future<void> updateExpense(int index, ExpenseModel expense);
  Future<void> deleteExpense(int index);
  Future<List<ExpenseModel>> getExpensesByCategory(String category);
  Future<List<ExpenseModel>> getExpensesByDateRange(DateTime start, DateTime end);
}