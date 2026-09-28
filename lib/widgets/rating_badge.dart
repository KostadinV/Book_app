import 'package:flutter/material.dart';

class RatingBadge extends StatelessWidget {
  final double rating;
  const RatingBadge({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$rating *',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.amber.shade700,
      ),
    );
  }
}
