import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_event.dart';
import 'package:flutter_web_fe/blocs/product/product_sate.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/animated_button.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/card_book.dart';

class ProductCarouselPage extends StatefulWidget {
  const ProductCarouselPage({super.key});

  @override
  State<ProductCarouselPage> createState() => _ProductCarouselPageState();
}

class _ProductCarouselPageState extends State<ProductCarouselPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ProductBloc>().add(const FetchProducts(page: 1, limit: 10));
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const FetchProducts(page: 1, limit: 10));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductInit) {
          context
              .read<ProductBloc>()
              .add(const FetchProducts(page: 1, limit: 10));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 0),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildCarousel(
              title: "Flash Sale",
              bloc: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductsLoaded) {
                    return _buildProductCarousel(state.products, true);
                  }
                  return _buildLoadingOrError(state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel({required String title, required Widget bloc}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: CustomColor.secondBlue,
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  child: CustomButton(
                width: 180,
                fontSize: 16,
                title: 'Show more',
                icon: Icons.arrow_forward,
                onPressed: () {},
              )),
            )
          ],
        ),
        const SizedBox(height: 10),
        bloc,
      ],
    );
  }

  Widget _buildProductCarousel(List<Product> products, bool reverse) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: CardBook(
              product: products[index],
            ),
          );
        },
        options: CarouselOptions(
          height: 500,
          viewportFraction: 0.2,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: reverse,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayAnimationDuration: const Duration(milliseconds: 1000),
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget _buildLoadingOrError(ProductState state) {
    if (state is ProductLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(CustomColor.primaryRed),
        ),
      );
    } else if (state is ProductError) {
      return Center(
        child: Text(
          'Lỗi: ${state.errorMessage}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    return const SizedBox();
  }
}
