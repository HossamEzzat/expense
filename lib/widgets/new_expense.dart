import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for HapticFeedback

import '../models/expenses_model.dart';
// Note: You must ensure 'formatter' is accessible, usually via a shared utility or the expenses_model.dart file.

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    // 1. Add Haptic Feedback on button press
    HapticFeedback.lightImpact();

    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final colorScheme = Theme.of(context).colorScheme;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
      builder: (context, child) {
        // Theme builder remains the same for custom DatePicker colors
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme.copyWith(
              primary: colorScheme.primary,
              onPrimary: Colors.white,
              surface: colorScheme.surface,
              onSurface: colorScheme.onSurface,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    HapticFeedback.mediumImpact(); // Haptic feedback for submit action

    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showErrorDialog();
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  void _showErrorDialog() {
    // Error dialog remains the same
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            const Text('Invalid Input'),
          ],
        ),
        content: const Text(
            'Please ensure a valid Title (not empty), Amount (> 0), and Date are selected.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate keyboard space and orientation once
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardSpace),
        child: Column(
          children: [
            // 2. Wrap inputs in a subtle card for visual grouping
            Card(
              margin: EdgeInsets.zero,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (ctx, constraints) {
                    final isWideScreen = constraints.maxWidth > 600;

                    if (isWideScreen) {
                      // LANDSCAPE/WIDE LAYOUT
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildTitleField()),
                          const SizedBox(width: 16),
                          Expanded(child: _buildAmountField()),
                          const SizedBox(width: 16),
                          _buildDatePickerRow(context, constraints.maxWidth),
                        ],
                      );
                    } else {
                      // PORTRAIT LAYOUT
                      return Column(
                        children: [
                          _buildTitleField(),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildAmountField()),
                              const SizedBox(width: 16),
                              _buildDatePickerRow(context, constraints.maxWidth),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 24), // Increased space between input card and controls

            // Category & Buttons Row (Shared)
            Row(
              children: [
                // Enhanced Dropdown (remains the same)
                SizedBox(
                  height: 48,
                  child: DropdownButton(
                    hint: const Text('Category'),
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (category) => DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Icon(categoryIcons[category], size: 20, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(category.name.toUpperCase()),
                          ],
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact(); // Haptic feedback for cancel
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton.icon(
                  onPressed: _submitExpenseData,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Save Expense'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // 3. Extracted TextField widgets for clarity
  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      maxLength: 50,
      decoration: InputDecoration(
        label: const Text('Title'),
        // Use filled property for a subtle background inside the field
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), // Softer corners
        helperText: 'e.g., Groceries or New Shoes',
        helperStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
        counterStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixText: '\$ ',
        label: const Text('Amount'),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Extracted Date Picker Row - adjusted to accept screen width from LayoutBuilder
  Widget _buildDatePickerRow(BuildContext context, double currentWidth) {
    return SizedBox(
      width: currentWidth > 600 ? 150 : null, // Fixed width for date field in wide mode
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _selectedDate == null
                ? 'Select Date'
                : formatter.format(_selectedDate!),
            style: TextStyle(
              color: _selectedDate == null ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600, // Make the date text bolder
            ),
          ),
          IconButton(
            onPressed: _presentDatePicker,
            icon: Icon(
              Icons.date_range, // Switched icon for a slightly different look
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}