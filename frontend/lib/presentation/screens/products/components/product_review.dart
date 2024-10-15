import 'package:flutter/material.dart';
import 'package:flutter_web_fe/core/data/models/comment_model.dart';

class ReviewProduct extends StatelessWidget {
  final List<Comment> commentProducts;

  const ReviewProduct({super.key, required this.commentProducts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: commentProducts.length,
      itemBuilder: (context, index) {
        final comment = commentProducts[index];
        return _buildReviewCard(comment);
      },
    );
  }

  Widget _buildReviewCard(Comment comment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  comment.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text(
                  comment.date.toString().split(' ')[0],
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(comment.content),
            const SizedBox(height: 5),
            Row(
              children: List.generate(
                comment.rating.isNotEmpty ? comment.rating.first : 0,
                (index) => const Icon(Icons.star, color: Colors.amber),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
