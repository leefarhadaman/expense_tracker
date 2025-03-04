import '../../domain/repositories/expense_repository.dart';
import '../datasources/local/expense_local_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl(this.localDataSource);

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await localDataSource.addExpense(expense);
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    return await localDataSource.getExpenses();
  }

  @override
  Future<void> updateExpense(int index, ExpenseModel expense) async {
    await localDataSource.updateExpense(index, expense);
  }

  @override
  Future<void> deleteExpense(int index) async {
    await localDataSource.deleteExpense(index);
  }

  @override
  Future<List<ExpenseModel>> getExpensesByCategory(String category) async {
    return await localDataSource.getExpensesByCategory(category);
  }

  @override
  Future<List<ExpenseModel>> getExpensesByDateRange(
      DateTime start,
      DateTime end,
      ) async {
    return await localDataSource.getExpensesByDateRange(start, end);
  }
}