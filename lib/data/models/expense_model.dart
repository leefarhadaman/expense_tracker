import 'package:hive/hive.dart';
import '../../../domain/entities/expense_entity.dart';

part 'expense_model.g.dart'; // This is necessary for Hive adapter generation

@HiveType(typeId: 0) // Unique type ID for Hive serialization
class ExpenseModel extends ExpenseEntity {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String category;

  ExpenseModel({
    this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.category,
  }) : super(
    id: id,
    amount: amount,
    date: date,
    description: description,
    category: category,
  );

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'category': category,
    };
  }
}
