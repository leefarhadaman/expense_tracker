import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_expense_usecase.dart';
import '../../domain/usecases/get_expenses_usecase.dart';
import '../../domain/usecases/delete_expense_usecase.dart';
import '../../domain/usecases/edit_expense_usecase.dart';
import '../../data/models/expense_model.dart';
import 'expense_state.dart';

class ExpenseBloc extends Cubit<ExpenseState> {
  final AddExpenseUseCase addExpenseUseCase;
  final GetExpensesUseCase getExpensesUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;

  ExpenseBloc({
    required this.addExpenseUseCase,
    required this.getExpensesUseCase,
    required this.deleteExpenseUseCase,
    required this.updateExpenseUseCase,
  }) : super(ExpenseInitial()) {
    // Fetch expenses when bloc is created
    fetchExpenses();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    try {
      emit(ExpenseLoading());
      await addExpenseUseCase(expense);
      await fetchExpenses();
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> updateExpense(int index, ExpenseModel expense) async {
    try {
      emit(ExpenseLoading());
      await updateExpenseUseCase(index, expense);
      await fetchExpenses();
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> deleteExpense(int index) async {
    try {
      emit(ExpenseLoading());
      await deleteExpenseUseCase(index);
      await fetchExpenses();
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> fetchExpenses() async {
    try {
      emit(ExpenseLoading());
      final expenses = await getExpensesUseCase();
      emit(ExpensesLoaded(expenses));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }
}