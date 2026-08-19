import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String mealId;

  const ProductDetailsScreen({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Product Details — TODO (id: $mealId)')),
    );
  }
}