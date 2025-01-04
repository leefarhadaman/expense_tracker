class Expense {
  final int id;
  final double amount;
  final String category;
  final String date;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
  });

  // Convert an Expense object into a Map object (for inserting into the database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date,
    };
  }

  // Convert a Map object into an Expense object (for fetching from the database)
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      date: map['date'],
    );
  }
}
