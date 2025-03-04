import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_state.dart';
import '../widgets/expense_item_widget.dart';
import 'add_expense_page.dart';
import 'expense_summary_page.dart';

class ExpenseListPage extends StatefulWidget {
  @override
  _ExpenseListPageState createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
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

  void _navigateWithAnimation(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeOutQuad;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Custom color palette
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
          title: Text(
            'Expense Tracker',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.analytics_outlined,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                  onPressed: () {
                    _navigateWithAnimation(ExpenseSummaryPage());
                  },
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (state is ExpenseLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                ),
              );
            }

            if (state is ExpenseError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 100,
                      color: colorScheme.error,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Something went wrong',
                      style: GoogleFonts.poppins(
                        color: colorScheme.error,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is ExpensesLoaded) {
              final expenses = state.expenses;

              if (expenses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.money_off_rounded,
                          size: 80,
                          color: colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'No expenses yet',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: colorScheme.onBackground.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return AnimationLimiter(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: expenses.length,
                  itemBuilder: (BuildContext context, int index) {
                    final expense = expenses[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ExpenseItemWidget(
                              expense: expense,
                              onDelete: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: Text(
                                      'Delete Expense',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete this expense?',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Cancel',
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          context.read<ExpenseBloc>().deleteExpense(index);
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: colorScheme.error,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Delete',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onEdit: () {
                                _navigateWithAnimation(
                                  AddExpensePage(
                                    expense: expense,
                                    index: index,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return Center(
              child: Text(
                'Something went wrong',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            );
          },
        ),
        floatingActionButton: Container(
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
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              _navigateWithAnimation(AddExpensePage());
            },
            child: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}