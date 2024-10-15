// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_web_fe/blocs/comment/comment_bloc.dart';
// import 'package:flutter_web_fe/blocs/comment/comment_event.dart';
// import 'package:flutter_web_fe/blocs/comment/comment_state.dart';
// import 'package:flutter_web_fe/presentation/screens/products/components/product_review.dart';

// class ProductsReviewWidget extends StatelessWidget {
//   final String productId;

//   const ProductsReviewWidget({super.key, required this.productId});

//   @override
//   Widget build(BuildContext context) {
//     context.read<CommentsBloc>().add(FetchComments(productId));
//     return BlocBuilder<CommentsBloc, CommentsState>(
//       builder: (context, state) {
//         if (state is CommentsLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is CommentsError) {
//           return Center(child: Text('Có lỗi xảy ra: ${state.error}'));
//         } else if (state is CommentsLoaded) {
//           final commentProducts = state.comments;

//           return ReviewProduct(commentProducts: commentProducts);
//         }

//         return const Center(child: Text('Không có sản phẩm nào.'));
//       },
//     );
//   }
// }
