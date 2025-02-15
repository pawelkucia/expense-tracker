import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final Function(Expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text('Invalid Input'),
          content: Text('Please enter a valid title, amount and date!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
      return;
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid Input'),
          content: Text('Please enter a valid title, amount and date!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _submitData() {
    final enteredTitle = _titleController.text.trim();
    final enteredAmount = double.tryParse(_amountController.text);

    var isInvalidAmount = enteredAmount == null || enteredAmount < 0;

    if (enteredTitle.isEmpty || isInvalidAmount || _selectedDate == null) {
      _showDialog();

      return;
    }

    final newExpense = Expense(
      title: enteredTitle,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    );

    widget.onAddExpense(newExpense);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, keyboardSpace + 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (width >= 600)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLength: 50,
                          decoration: InputDecoration(labelText: 'Title'),
                          controller: _titleController,
                          onSubmitted: (_) => _submitData(),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            prefixText: '\$',
                          ),
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          onSubmitted: (_) => _submitData(),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    maxLength: 50,
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                    onSubmitted: (_) => _submitData(),
                  ),
                Row(
                  children: [
                    if (width < 600)
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            prefixText: '\$',
                          ),
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          onSubmitted: (_) => _submitData(),
                        ),
                      ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'No Date Chosen!'
                                  : formatter.format(_selectedDate!),
                            ),
                          ),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _submitData,
                      child: Text('Add Expense'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
