import '../repositories/expense_repository.dart';
import '../../data/models/expense_model.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> call(ExpenseModel expense) async {
    await repository.addExpense(expense);
  }
}
