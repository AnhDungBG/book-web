import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_event.dart';
import 'package:flutter_web_fe/blocs/product/product_sate.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/card_book.dart';

class TagProductsWidget extends StatelessWidget {
  final List<String> tags;

  const TagProductsWidget({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(FetchProductsByTags(tags));

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is TagProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductError) {
          return Center(child: Text('Có lỗi xảy ra: ${state.errorMessage}'));
        } else if (state is TagProductsLoaded) {
          final products = state.productTags;

          return SizedBox(
            height: 420,
            width: double.infinity,
            child: CarouselSlider.builder(
              itemCount: products.length,
              itemBuilder: (context, index, realIndex) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    child: CardBook(product: product),
                  ),
                );
              },
              options: CarouselOptions(
                height: 400,
                autoPlay: true,
                viewportFraction: 1 / 5,
                autoPlayInterval: const Duration(seconds: 3),
                scrollDirection: Axis.horizontal,
              ),
            ),
          );
        }
        return const Center(child: Text('Không có sản phẩm nào.'));
      },
    );
  }
}
