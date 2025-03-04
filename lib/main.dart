// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'data/datasources/local/expense_local_datasource.dart';
import 'data/datasources/notification/notification_service.dart';
import 'data/models/expense_model.dart';
import 'data/repositories/expense_repository_impl.dart';
import 'domain/repositories/expense_repository.dart';
import 'domain/usecases/add_expense_usecase.dart';
import 'domain/usecases/delete_expense_usecase.dart';
import 'domain/usecases/edit_expense_usecase.dart';
import 'domain/usecases/get_expenses_usecase.dart';
import 'presentation/bloc/expense_bloc.dart';
import 'presentation/pages/expense_list_page.dart';
import 'core/constants/app_colors.dart';

void main() async {
  // Ensure Flutter is initialized before using async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register adapters
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());

  // Open Hive box for expenses
  await Hive.openBox<ExpenseModel>('expenses');

  // Initialize Notification Service
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final NotificationService notificationService =
  NotificationService(flutterLocalNotificationsPlugin);

  // Initialize and schedule notifications
  await notificationService.initialize();
  await notificationService.scheduleDailyReminder();

  // Setup Dependencies
  final ExpenseLocalDataSource localDataSource = ExpenseLocalDataSource();
  final ExpenseRepository repository = ExpenseRepositoryImpl(localDataSource);

  // Initialize Use Cases
  final AddExpenseUseCase addExpenseUseCase = AddExpenseUseCase(repository);
  final GetExpensesUseCase getExpensesUseCase = GetExpensesUseCase(repository);
  final DeleteExpenseUseCase deleteExpenseUseCase = DeleteExpenseUseCase(repository);
  final UpdateExpenseUseCase updateExpenseUseCase = UpdateExpenseUseCase(repository);

  // Run App with Bloc Providers
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ExpenseBloc>(
          create: (context) => ExpenseBloc(
            addExpenseUseCase: addExpenseUseCase,
            getExpensesUseCase: getExpensesUseCase,
            deleteExpenseUseCase: deleteExpenseUseCase,
            updateExpenseUseCase: updateExpenseUseCase,
          ),
        ),
      ],
      child: ExpenseTrackerApp(),
    ),
  );
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: AppColors.primaryColor,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: ExpenseListPage(),
    );
  }
}