import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_event.dart';
import 'package:flutter_web_fe/blocs/product/product_sate.dart';
import 'package:flutter_web_fe/presentation/screens/products/components/product_quick_cart.dart';

class AuthorProductsWidget extends StatelessWidget {
  final String authorName;

  const AuthorProductsWidget({super.key, required this.authorName});

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(FetchAuthorProducts(authorName));

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is AuthorProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AuthorProductsError) {
          return Center(child: Text('Có lỗi xảy ra: ${state.error}'));
        } else if (state is AuthorProductsLoaded) {
          final productsByAuthor = state.authorProducts;

          if (productsByAuthor.isEmpty) {
            return const Center(child: Text('Không có sản phẩm nào.'));
          }

          return ListView.builder(
            itemCount: productsByAuthor.length,
            itemBuilder: (context, index) {
              final product = productsByAuthor[index];
              return ProductQuickCart(product: product);
            },
          );
        }

        return const Center(child: Text('Không có dữ liệu.'));
      },
    );
  }
}
