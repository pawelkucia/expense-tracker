import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Choco bar',
        amount: 10.22,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Bus ticket',
        amount: 5.00,
        date: DateTime.now(),
        category: Category.transportation),
    Expense(
        title: 'T-shirt',
        amount: 20.00,
        date: DateTime.now(),
        category: Category.clothing),
  ];

  void _openAddExpenseDialog() {
    showModalBottomSheet(context: context, builder: (ctx) {
      return Text('Add expense dialog');
    })
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _openAddExpenseDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Text('Expenses will be shown here'),
          ),
          Expanded(
            child: ExpensesList(expenses: _registeredExpenses),
          ),
        ],
      ),
    );
  }
}
