import 'package:flutter/material.dart';

class ProductDiscountPercentageView extends StatelessWidget {
  const ProductDiscountPercentageView({
    super.key,
    required this.discountPercentage,
  });

  final double discountPercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${discountPercentage.toStringAsFixed(0)}% OFF',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
