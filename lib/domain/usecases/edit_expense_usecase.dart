import '../repositories/expense_repository.dart';
import '../../data/models/expense_model.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository repository;

  UpdateExpenseUseCase(this.repository);

  Future<void> call(int index, ExpenseModel expense) async {
    await repository.updateExpense(index, expense);
  }
}