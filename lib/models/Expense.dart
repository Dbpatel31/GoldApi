import 'package:hive/hive.dart';
part 'Expense.g.dart';


@HiveType(typeId: 1)
class Expense extends HiveObject{
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

    Expense({
     required this.id,
    required this.title,
    required this.amount,
    required this.description,
    required this.createdAt,
    required this.updatedAt
   });

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt
  }){
     return Expense(
         id: id ?? this.id,
         title: title ?? this.title,
         amount: amount ?? this.amount,
         description: description ?? this.description,
         createdAt: createdAt ?? this.createdAt,
         updatedAt: updatedAt ?? this.updatedAt
     );
  }

  Map<String, dynamic>toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String()
  };

  factory Expense.fromJson(Map<String, dynamic>j) => Expense(
      id: j['id'],
      title: j['title'],
      amount: (j['amount'] as num).toDouble(),
      description: j['description'] ?? '',
      createdAt: DateTime.parse(j['createdAt']),
      updatedAt: DateTime.parse(j['updatedAt'])
  );

}