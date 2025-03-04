// presentation/bloc/expense_state.dart
import '../../data/models/expense_model.dart';

abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpensesLoaded extends ExpenseState {
  final List<ExpenseModel> expenses;

  ExpensesLoaded(this.expenses);
}

class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError(this.message);
}