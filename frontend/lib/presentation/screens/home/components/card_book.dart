import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/myFavoriteProduct/my_favorite_bloc.dart';
import 'package:flutter_web_fe/blocs/myFavoriteProduct/my_favorite_event.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';
import 'package:intl/intl.dart';

class CardBook extends StatelessWidget {
  final Product product;
  final bool isSimpleView;

  const CardBook({
    super.key,
    required this.product,
    this.isSimpleView = false,
  });

  @override
  Widget build(BuildContext context) {
    return isSimpleView
        ? _buildSimpleView(context)
        : _buildDetailedView(context);
  }

  Widget _buildSimpleView(BuildContext context) {
    return GestureDetector(
      onTap: () => Beamer.of(context).beamToNamed('/products/${product.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductTitle(),
                const SizedBox(height: 4),
                _buildPriceInfo(),
                const SizedBox(height: 4),
                _buildRatingAndSoldInfo(),
                const SizedBox(height: 8),
                _buildAddToCartButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedView(BuildContext context) {
    return SizedBox(
      width: 300,
      child: GestureDetector(
        onTap: () => Beamer.of(context).beamToNamed('/products/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(context),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductTitle(),
                  const SizedBox(height: 4),
                  _buildPriceInfo(),
                  const SizedBox(height: 4),
                  _buildRatingAndSoldInfo(),
                  _buildAddToCartButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return isSimpleView
        ? HoverableProductImageSimple(
            product: product,
          )
        : HoverableProductImage(
            product: product,
            onFavorite: () {
              context
                  .read<MyFavoriteProductBloc>()
                  .add(AddMyFavoriteProduct(product.id));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product added to favorites!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            onView: () {/* TODO: Implement view functionality */},
          );
  }

  Widget _buildProductTitle() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Text(
        product.title ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: isSimpleView ? 16 : 18,
          fontWeight: FontWeight.bold,
          color: isSimpleView ? Colors.black : CustomColor.secondBlue,
        ),
      ),
    );
  }

  Widget _buildPriceInfo() {
    return Row(
      children: [
        Text(
          '${NumberFormat.currency(locale: 'vi', symbol: '').format(product.price)} đ',
          style: TextStyle(
            fontSize: isSimpleView ? 14 : 17,
            fontWeight: FontWeight.bold,
            color: CustomColor.primaryRed,
          ),
        ),
        if (product.marketPrice != null &&
            product.marketPrice! > product.price!)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              '${NumberFormat.currency(locale: 'vi', symbol: '').format(product.marketPrice)} đ',
              style: TextStyle(
                fontSize: isSimpleView ? 12 : 14,
                decoration: TextDecoration.lineThrough,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRatingAndSoldInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            Text(
              ' ${product.rating.toStringAsFixed(1)}',
              style: TextStyle(fontSize: isSimpleView ? 12 : 14),
            ),
          ],
        ),
        Text(
          'Đã bán ${product.soldCount}',
          style:
              TextStyle(fontSize: isSimpleView ? 12 : 14, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return HoverableAddToCartButton(
      onTap: () {/* TODO: Implement add to cart functionality */},
      isSimpleView: isSimpleView,
    );
  }

  Widget _buildPromotionBadge() {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: CustomColor.primaryRed,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '-${((product.promotion?.discount ?? 0) * 100).toStringAsFixed(0)}%',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class HoverableProductImage extends StatefulWidget {
  final Product product;
  final VoidCallback onFavorite;
  final VoidCallback onView;

  const HoverableProductImage({
    super.key,
    required this.product,
    required this.onFavorite,
    required this.onView,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HoverableProductImageState createState() => _HoverableProductImageState();
}

class _HoverableProductImageState extends State<HoverableProductImage> {
  bool _isHoverImage = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHoverImage = true),
          onExit: (_) => setState(() => _isHoverImage = false),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: CustomColor.lightGray,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildProductImage(),
                _buildHoverIcons(),
              ],
            ),
          ),
        ),
        if (widget.product.promotion != null) _buildPromotionBadge(),
      ],
    );
  }

  Widget _buildProductImage() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Transform.scale(
          scale: _isHoverImage ? 1.01 : 1.0,
          child: Image.network(
            widget.product.imageUrl != null &&
                    widget.product.imageUrl!.isNotEmpty
                ? (widget.product.imageUrl!.startsWith('http')
                    ? widget.product.imageUrl!
                    : 'http://localhost:99${widget.product.imageUrl}')
                : 'https://example.com/default_image.png',
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          )),
    );
  }

  Widget _buildHoverIcons() {
    return Positioned(
      top: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _isHoverImage ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(_isHoverImage ? 0 : 20, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconButton(Icons.favorite_border, widget.onFavorite),
              const SizedBox(height: 10),
              _buildIconButton(Icons.visibility, widget.onView),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionBadge() {
    return Positioned(
      top: 15,
      left: 15,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: CustomColor.primaryRed,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '-${((widget.product.promotion?.discount ?? 0) * 100).toStringAsFixed(0)}%',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.black),
      onPressed: () {
        print(" button pressed!"); // Add this to check if it's triggered
        onPressed(); // This will call the passed callback
      },
    );
  }
}

class HoverableProductImageSimple extends StatefulWidget {
  final Product product;

  const HoverableProductImageSimple({
    super.key,
    required this.product,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HoverableProductImageSimpleState createState() =>
      _HoverableProductImageSimpleState();
}

class _HoverableProductImageSimpleState
    extends State<HoverableProductImageSimple> {
  bool _isHoverImage = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isHoverImage = true),
            onExit: (_) => setState(() => _isHoverImage = false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              color: CustomColor.grayLightBackground,
              child: Stack(
                children: [
                  Center(child: _buildProductImage()),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildProductImage() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeInOut,
      child: Transform.scale(
        scale: _isHoverImage ? 1.03 : 1.0,
        child: Image.network(
          '${widget.product.imageUrl}',
          height: 190,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class HoverableAddToCartButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isSimpleView;

  const HoverableAddToCartButton({
    super.key,
    required this.onTap,
    required this.isSimpleView,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HoverableAddToCartButtonState createState() =>
      _HoverableAddToCartButtonState();
}

class _HoverableAddToCartButtonState extends State<HoverableAddToCartButton> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHover = true),
      onExit: (_) => setState(() => _isHover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: widget.isSimpleView
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
              : const EdgeInsets.all(5),
          margin: widget.isSimpleView
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          decoration: BoxDecoration(
            gradient: _isHover
                ? const LinearGradient(
                    colors: [CustomColor.coolGray, CustomColor.lightGray],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : LinearGradient(
                    colors: [Colors.grey.shade100, Colors.grey.shade100],
                  ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                color: _isHover ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 10),
              Text(
                'Add to cart',
                style: TextStyle(
                  color: _isHover
                      ? widget.isSimpleView
                          ? CustomColor.lightGray
                          : const Color.fromARGB(255, 105, 105, 105)
                      : Colors.black,
                  fontSize: widget.isSimpleView ? 13 : 13,
                  fontWeight:
                      widget.isSimpleView ? FontWeight.w400 : FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
