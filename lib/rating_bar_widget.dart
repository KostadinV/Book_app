import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StarRatingBar extends StatefulWidget {
  final ValueChanged<double> onRatingChanged;

  const StarRatingBar({super.key, required this.onRatingChanged});

  @override
  State<StarRatingBar> createState() => _StarRatingBarState();
}

class _StarRatingBarState extends State<StarRatingBar> {
  double _rating = 3.0;
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: _rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: Colors.amber.withValues(alpha: 0.4),
      itemCount: 5,
      itemSize: 60,
      glow: false,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) =>
          const Icon(Icons.star_rounded, color: Colors.amber),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
        widget.onRatingChanged(rating);
      },
    );
  }
}
