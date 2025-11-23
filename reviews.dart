import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, i) => Card(
          child: ListTile(
            title: Row(children: [
              Text('Provider ${i+1}'),
              const SizedBox(width: 8),
              RatingBarIndicator(rating: 4.0 - (i % 3)*0.5, itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber), itemCount: 5, itemSize: 18.0),
            ]),
            subtitle: const Text('Service was great and on time.'),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: 5,
      ),
    );
  }
}
