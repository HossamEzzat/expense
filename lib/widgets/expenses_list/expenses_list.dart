import 'package:flutter/material.dart';

import '../../models/expenses_model.dart';
import 'expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    // Get the horizontal margin from the card theme for precise alignment
    final horizontalMargin = Theme.of(context).cardTheme.margin!.horizontal;

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        direction: DismissDirection.endToStart, // Only allow swiping from right to left

        // --- Enhanced Background ---
        background: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error, // Use full error color
            borderRadius: BorderRadius.circular(12), // Match the card's border radius
          ),
          margin: EdgeInsets.symmetric(
            horizontal: horizontalMargin,
            vertical: 4, // Add slight vertical margin for separation
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete_sweep_rounded, // Use a clear delete icon
            color: Colors.white, // Ensure icon is visible against the background
            size: 36,
          ),
        ),
        // --- End Enhanced Background ---

        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(
          expenses[index],
        ),
      ),
    );
  }
}