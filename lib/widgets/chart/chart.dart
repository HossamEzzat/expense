import 'package:flutter/material.dart';

import '../../models/expenses_model.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  // --- (Your existing getters remain the same) ---
  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.food),
      ExpenseBucket.forCategory(expenses, Category.leisure),
      ExpenseBucket.forCategory(expenses, Category.travel),
      ExpenseBucket.forCategory(expenses, Category.work),
    ];
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }

    return maxTotalExpense;
  }
  // --- (End existing getters) ---

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16), // Adjusted top margin
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16), // Increased vertical padding
      width: double.infinity,
      // Removed fixed height; relying on padding/content for better responsiveness
      // height: 180,
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(isDarkMode ? 0.2 : 0.1), // Subtle background color
        borderRadius: BorderRadius.circular(16), // Increased corner radius for a softer look
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 0.5,
        ),
        // Simplified gradient for a cleaner look
        // gradient: LinearGradient(
        //   colors: [
        //     colorScheme.primary.withOpacity(0.3),
        //     colorScheme.primary.withOpacity(0.0)
        //   ],
        //   begin: Alignment.bottomCenter,
        //   end: Alignment.topCenter,
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Chart Title/Label
          Text(
            'Weekly Expense Overview',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          // 2. Main Chart Area (Expanded)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              // Added horizontal padding for the bars section
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final bucket in buckets)
                // Wrap ChartBar in Expanded for even distribution
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChartBar(
                        fill: bucket.totalExpenses == 0
                            ? 0
                            : bucket.totalExpenses / maxTotalExpense,
                      ),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Separator Line
          Divider(
            height: 1,
            color: colorScheme.outline.withOpacity(0.5),
            indent: 8,
            endIndent: 8,
          ),
          const SizedBox(height: 8),

          // 4. Category Icons/Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: buckets
                .map(
                  (bucket) => Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Icon(
                      categoryIcons[bucket.category],
                      size: 24, // Slightly larger icon
                      color: colorScheme.primary,
                    ),
                    // Label (Optional: uncomment for text label below icon)
                    /*
                        Text(
                          bucket.category.name.substring(0, 1).toUpperCase(), // Short label
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        */
                  ],
                ),
              ),
            )
                .toList(),
          )
        ],
      ),
    );
  }
}