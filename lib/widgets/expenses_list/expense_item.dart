import 'package:flutter/material.dart';

import '../../models/expenses_model.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    // Determine the color scheme for better contrast
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      // 1. Enhanced Card Styling
      elevation: 3, // Add subtle shadow
      margin: const EdgeInsets.symmetric(
        horizontal: 8, // Match the spacing used in ExpensesList
        vertical: 4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Nicely rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Highlight Title
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold, // Make title bolder
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8), // Increased vertical space

            Row(
              children: [
                // 3. Highlight Amount (Price Tag Container)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: colorScheme.secondary.withOpacity(0.7),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    // Format amount with currency symbol
                    '\$${expense.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.secondary,
                      fontSize: 16,
                    ),
                  ),
                ),

                const Spacer(),

                // 4. Category and Date Info
                Row(
                  children: [
                    // Highlight the category icon with a distinct color
                    Icon(
                      categoryIcons[expense.category],
                      color: colorScheme.primary, // Use a primary accent color
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    // Use a subtle text style for the date
                    Text(
                      expense.formattedDate,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}