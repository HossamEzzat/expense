import 'package:flutter/material.dart';

import '../models/expenses_model.dart';
import 'chart/chart.dart';
import 'expenses_list/expenses_list.dart';
import 'new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  // ... (Your existing _registeredExpenses, _openAddExpenseOverlay, _addExpense, _removeExpense methods remain the same) ...
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    // Added a few more for better list visualization
    Expense(
      title: 'Groceries',
      amount: 45.30,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: Category.food,
    ),
    Expense(
      title: 'Train Ticket',
      amount: 5.50,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: Category.travel,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      // Apply a rounded border radius to the top of the modal
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        // Use a better primary color for the SnackBar
        backgroundColor: Theme.of(context).colorScheme.error,
        content: const Text('Expense deleted.', style: TextStyle(color: Colors.white)),
        action: SnackBarAction(
          label: 'Undo',
          // Use a strong color for the action button
          textColor: Theme.of(context).colorScheme.onPrimaryContainer,
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Get device dimensions and orientation
    final width = MediaQuery.of(context).size.width;
    final isLandscape = width > 600; // Define a threshold for "wide" screens

    Widget mainContent = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
              Icons.sentiment_dissatisfied,
              size: 60,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5)
          ),
          const SizedBox(height: 16),
          Text(
            'No expenses found. Start adding some!',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        // Enhance AppBar with subtle elevation and better title styling
        title: Text(
          'Flutter ExpenseTracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 4,
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add_circle_outline, size: 28),
            // Use an accent color for the icon
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ],
      ),
      // Apply consistent padding to the body
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: isLandscape // Check if in landscape/wide mode
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chart takes up 40% of the screen width
            Expanded(
              flex: 1, // Give the chart slightly less space
              child: Chart(expenses: _registeredExpenses),
            ),
            const SizedBox(width: 16),
            // List takes up 60% of the screen width
            Expanded(
              flex: 2, // Give the list more space for items
              child: mainContent,
            ),
          ],
        )
            : Column(
          children: [
            // Chart area is given a fixed vertical space for better presentation
            SizedBox(
                height: 200,
                child: Chart(expenses: _registeredExpenses)
            ),
            const SizedBox(height: 16),
            // Add a subtle divider before the list
            const Divider(thickness: 1),
            const SizedBox(height: 8),

            Expanded(
              child: mainContent,
            ),
          ],
        ),
      ),
    );
  }
}