import 'package:flutter/material.dart';
import 'widgets/expenses_screen.dart';


void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Expenses(),
    ),
  );
}