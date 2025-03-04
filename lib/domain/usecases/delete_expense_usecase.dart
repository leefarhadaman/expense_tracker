import '../repositories/expense_repository.dart';
import '../../data/models/expense_model.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository repository;

  DeleteExpenseUseCase(this.repository);

  Future<void> call(int index) async {
    await repository.deleteExpense(index);
  }
}