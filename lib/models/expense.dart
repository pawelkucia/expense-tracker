import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

enum Category {
  food,
  transportation,
  housing,
  utilities,
  clothing,
  health,
  insurance,
  personal,
  education,
  entertainment,
  miscellaneous,
}

const categoryIcons = {
  Category.food: Icons.fastfood,
  Category.transportation: Icons.directions_bus,
  Category.housing: Icons.home,
  Category.utilities: Icons.flash_on,
  Category.clothing: Icons.shopping_bag,
  Category.health: Icons.medical_services,
  Category.insurance: Icons.local_hospital,
  Category.personal: Icons.person,
  Category.education: Icons.school,
  Category.entertainment: Icons.movie,
  Category.miscellaneous: Icons.more_horiz,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}
