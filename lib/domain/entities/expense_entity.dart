class ExpenseEntity {
  final int? id;
  final double amount;
  final DateTime date;
  final String description;
  final String category;

  ExpenseEntity({
    this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.category,
  });
}