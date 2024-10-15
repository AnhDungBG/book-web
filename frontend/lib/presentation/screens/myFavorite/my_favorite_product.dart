import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_web_fe/blocs/myFavoriteProduct/my_favorite_bloc.dart';
import 'package:flutter_web_fe/blocs/myFavoriteProduct/my_favorite_event.dart';
import 'package:flutter_web_fe/blocs/myFavoriteProduct/my_favorite_state.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';
import 'package:flutter_web_fe/core/data/models/my_favorite_model.dart';
import 'package:flutter_web_fe/presentation/components/footer_desktop.dart';
import 'package:flutter_web_fe/presentation/components/header_desktop.dart';

class MyFavoriteProductsScreen extends StatefulWidget {
  const MyFavoriteProductsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyFavoriteProductsScreenState createState() =>
      _MyFavoriteProductsScreenState();
}

class _MyFavoriteProductsScreenState extends State<MyFavoriteProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyFavoriteProductBloc>().add(const FetchMyFavoriteProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderDesktop(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              child: BlocBuilder<MyFavoriteProductBloc, MyFavoriteProductState>(
                builder: (context, state) {
                  if (state is MyFavoriteProductsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MyFavoriteProductsLoaded) {
                    final products = state.myFavoriteProducts;
                    if (products.isEmpty) {
                      return const Center(
                          child: Text('Không tìm thấy sản phẩm yêu thích.'));
                    }
                    return _buildProductGrid(
                        products); // Changed from list to grid
                  } else if (state is MyFavoriteProductsError) {
                    return Center(child: Text('Lỗi: ${state.error}'));
                  }
                  return const Center(
                      child: Text('Không có dữ liệu sẵn sàng.'));
                },
              ),
            ),
          ),
          const CustomFooter(), // Thêm footer vào đây
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<FavoriteProduct> products) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Show 3 items per row on larger screens
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 3 / 2, // Aspect ratio for each card
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return CardBook(
          product: products[index].product,
          favoriteId: products[index].id,
          onRemove: () {
            context
                .read<MyFavoriteProductBloc>()
                .add(RemoveMyFavoriteProduct(products[index].id));
          },
        );
      },
    );
  }
}

class CardBook extends StatelessWidget {
  final Product product;
  final int favoriteId;
  final VoidCallback onRemove;

  const CardBook(
      {super.key,
      required this.product,
      required this.favoriteId,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Beamer.of(context).beamToNamed('/products/${product.id}');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: CustomColor.lightGray,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductTitle(),
                  const SizedBox(height: 10),
                  _buildProductPrice(),
                  const SizedBox(height: 12),
                  _buildAddToCartButton(),
                  const SizedBox(height: 8),
                  _buildRemoveButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Image.network(
        product.imageUrl ?? '',
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductTitle() {
    return Text(
      product.title ?? 'N/A',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProductPrice() {
    return Row(
      children: [
        if (product.promotion?.discount != null)
          Text(
            '${product.price?.toStringAsFixed(2) ?? 'N/A'} đ',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.red,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        const SizedBox(width: 8),
        Text(
          '${product.price?.toStringAsFixed(2) ?? 'N/A'} đ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: CustomColor.secondBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColor.primaryBlue,
        textStyle: const TextStyle(fontSize: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: const Text('Thêm vào giỏ hàng'),
    );
  }

  Widget _buildRemoveButton() {
    return TextButton(
      onPressed: onRemove,
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
        textStyle: const TextStyle(fontSize: 12),
      ),
      child: const Text('Xóa sản phẩm'),
    );
  }
}
