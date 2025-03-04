import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/expense_model.dart';
import '../bloc/expense_bloc.dart';

class AddExpensePage extends StatefulWidget {
  final ExpenseModel? expense;
  final int? index;

  const AddExpensePage({Key? key, this.expense, this.index}) : super(key: key);

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late DateTime _selectedDate;
  late String _selectedCategory;

  final List<String> _categories = [
    'Food',
    'Transportation',
    'Entertainment',
    'Bills',
    'Shopping',
    'Other'
  ];

  final List<IconData> _categoryIcons = [
    Icons.restaurant,
    Icons.directions_bus,
    Icons.movie,
    Icons.receipt,
    Icons.shopping_bag,
    Icons.category_outlined,
  ];

  @override
  void initState() {
    super.initState();
    // Animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Fade and slide animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuad,
      ),
    );

    // Start the animation
    _animationController.forward();

    // Initialize controllers and data
    _amountController = TextEditingController(
      text: widget.expense?.amount.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.expense?.description ?? '',
    );
    _selectedDate = widget.expense?.date ?? DateTime.now();
    _selectedCategory = widget.expense?.category ?? 'Other';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFF6A5ACD),
              primary: Color(0xFF6A5ACD),
            ),
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _submitExpense() {
    if (!_formKey.currentState!.validate()) return;

    final expenseModel = ExpenseModel(
      amount: double.parse(_amountController.text),
      date: _selectedDate,
      description: _descriptionController.text,
      category: _selectedCategory,
    );

    if (widget.expense == null) {
      // Adding new expense
      context.read<ExpenseBloc>().addExpense(expenseModel);
    } else {
      // Updating existing expense
      context.read<ExpenseBloc>().updateExpense(widget.index!, expenseModel);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Custom color scheme
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Color(0xFF6A5ACD),
      brightness: Brightness.light,
    );

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
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
              widget.expense == null ? 'Add New Expense' : 'Edit Expense',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Amount Input with Animated Container
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
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
                    child: TextFormField(
                      controller: _amountController,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: colorScheme.primary,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: GoogleFonts.poppins(),
                        prefixIcon: Icon(
                          Icons.currency_rupee,
                          color: colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),

                  // Description Input
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
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
                    child: TextFormField(
                      controller: _descriptionController,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: colorScheme.primary,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: GoogleFonts.poppins(),
                        prefixIcon: Icon(
                          Icons.description,
                          color: colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),

                  // Date Picker
                  Container(
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
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(
                            Icons.calendar_today,
                            color: colorScheme.primary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            DateFormat('MMMM dd, yyyy').format(_selectedDate),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _presentDatePicker,
                          child: Text(
                            'Change',
                            style: GoogleFonts.poppins(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Category Dropdown
                  Container(
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
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        prefixIcon: Icon(
                          _categoryIcons[_categories.indexOf(_selectedCategory)],
                          color: colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: colorScheme.primary,
                      ),
                      items: _categories
                          .asMap()
                          .entries
                          .map((entry) => DropdownMenuItem(
                        value: entry.value,
                        child: Text(
                          entry.value,
                          style: GoogleFonts.poppins(),
                        ),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 24),

                  // Submit Button with Gradient
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
                    child: ElevatedButton(
                      onPressed: _submitExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        widget.expense == null ? 'Add Expense' : 'Update Expense',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}