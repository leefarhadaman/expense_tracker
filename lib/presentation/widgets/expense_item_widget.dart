import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/expense_model.dart';
import 'package:intl/intl.dart';

class ExpenseItemWidget extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  ExpenseItemWidget({
    required this.expense,
    required this.onDelete,
    required this.onEdit,
  });

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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transportation':
        return Icons.directions_bus;
      case 'Entertainment':
        return Icons.movie;
      case 'Bills':
        return Icons.receipt;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Other':
        return Icons.category;
      default:
        return Icons.money;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(expense.category);
    final categoryIcon = _getCategoryIcon(expense.category);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.1),
          //     spreadRadius: 2,
          //     blurRadius: 5,
          //     offset: Offset(0, 3),
          //   ),
          // ],
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              categoryIcon,
              color: categoryColor,
              size: 28,
            ),
          ),
          title: Text(
            expense.description,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹${expense.amount.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(expense.date),
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue.shade300,
                ),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red.shade300,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}