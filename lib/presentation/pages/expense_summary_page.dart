import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_state.dart';
import '../../data/models/expense_model.dart';

class ExpenseSummaryPage extends StatefulWidget {
  @override
  _ExpenseSummaryPageState createState() => _ExpenseSummaryPageState();
}

class _ExpenseSummaryPageState extends State<ExpenseSummaryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Map<String, double> _calculateCategoryTotals(List<ExpenseModel> expenses) {
    Map<String, double> categoryTotals = {};

    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return categoryTotals;
  }

  double _calculateTotalExpenses(List<ExpenseModel> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Color(0xFFFF6B6B);
      case 'Transportation':
        return Color(0xFF4ECDC4);
      case 'Entertainment':
        return Color(0xFF45B7D1);
      case 'Bills':
        return Color(0xFF6A5ACD);
      case 'Shopping':
        return Color(0xFFFFA726);
      case 'Other':
        return Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Color(0xFF6A5ACD),
      brightness: Brightness.light,
    );

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: colorScheme.primary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Expense Summary',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ),
        body: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (state is ExpenseLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colorScheme.primary),
                ),
              );
            }

            if (state is ExpenseError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
              );
            }

            if (state is ExpensesLoaded) {
              final expenses = state.expenses;

              if (expenses.isEmpty) {
                return Center(
                  child: Text(
                    'No expenses to summarize',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              final categoryTotals = _calculateCategoryTotals(expenses);
              final totalExpenses = _calculateTotalExpenses(expenses);

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Total Expenses Card
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.primary.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Total Expenses',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '\₹${totalExpenses.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Pie Chart Card
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'Expenses by Category',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                height: 300,
                                child: PieChart(
                                  PieChartData(
                                    sections:
                                        categoryTotals.entries.map((entry) {
                                      final percentage =
                                          (entry.value / totalExpenses) * 100;
                                      return PieChartSectionData(
                                        color: _getCategoryColor(entry.key),
                                        value: entry.value,
                                        title:
                                            '${entry.key}\n${percentage.toStringAsFixed(1)}%',
                                        radius: 100,
                                      );
                                    }).toList(),
                                    centerSpaceRadius: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Detailed Breakdown Card
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'Detailed Breakdown',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              ...categoryTotals.entries.map((entry) {
                                final percentage =
                                    (entry.value / totalExpenses) * 100;
                                return ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(entry.key)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.category,
                                      color: _getCategoryColor(entry.key),
                                    ),
                                  ),
                                  title: Text(
                                    entry.key,
                                    style: GoogleFonts.poppins(),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '\₹${entry.value.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${percentage.toStringAsFixed(1)}%',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Monthly Trend Card
                      _buildMonthlyTrendCard(expenses, colorScheme),
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: Text(
                'Something went wrong',
                style: GoogleFonts.poppins(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonthlyTrendCard(
      List<ExpenseModel> expenses, ColorScheme colorScheme) {
    // Group expenses by month
    Map<String, double> monthlyExpenses = {};

    for (var expense in expenses) {
      String monthKey =
          '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';
      monthlyExpenses[monthKey] =
          (monthlyExpenses[monthKey] ?? 0) + expense.amount;
    }

    // Sort monthly expenses
    var sortedMonths = monthlyExpenses.keys.toList()..sort();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Monthly Expense Trend',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: sortedMonths.map((month) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        month,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '\₹${monthlyExpenses[month]!.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
