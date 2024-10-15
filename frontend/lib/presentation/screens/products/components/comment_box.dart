import 'package:flutter/material.dart';
import 'package:flutter_web_fe/core/data/models/review_model.dart';

class CommentBox extends StatefulWidget {
  final Function(Review) onAddReview; // Thêm hàm callback

  const CommentBox({super.key, required this.onAddReview});

  @override
  // ignore: library_private_types_in_public_api
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  int _rating = 0; // Biến để lưu trữ điểm đánh giá

  void _submitReview() {
    if (_commentController.text.isNotEmpty && _nameController.text.isNotEmpty) {
      final newReview = Review(
        name: _nameController.text,
        comment: _commentController.text,
        rating: _rating,
        date: DateTime.now(),
      );
      widget.onAddReview(newReview); // Gọi hàm callback để thêm bình luận
      _commentController.clear();
      _nameController.clear();
      setState(() {
        _rating = 0; // Đặt lại điểm đánh giá
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GỬI ĐÁNH GIÁ CỦA BẠN:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Nhập tên của bạn...'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _commentController,
          decoration:
              const InputDecoration(hintText: 'Nhập bình luận của bạn...'),
          maxLines: 3,
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  _rating = index + 1;
                });
              },
            );
          }),
        ),
        ElevatedButton(
          onPressed: _submitReview,
          child: const Text('Gửi bình luận'),
        ),
      ],
    );
  }
}
