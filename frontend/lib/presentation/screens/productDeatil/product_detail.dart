// ignore_for_file: library_private_types_in_public_api

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/myFavoriteProduct/my_favorite_bloc.dart';
import 'package:flutter_web_fe/blocs/myFavoriteProduct/my_favorite_event.dart';
import 'package:flutter_web_fe/blocs/myFavoriteProduct/my_favorite_state.dart';
import 'package:flutter_web_fe/blocs/product/product_event.dart';
import 'package:flutter_web_fe/blocs/product/product_sate.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';
import 'package:flutter_web_fe/blocs/product/product_bloc.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_web_fe/presentation/components/footer_desktop.dart';
import 'package:flutter_web_fe/presentation/components/header_desktop.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/card_book.dart';
import 'package:flutter_web_fe/blocs/cart/cart_bloc.dart';
import 'package:flutter_web_fe/blocs/cart/cart_event.dart';
import 'package:flutter_web_fe/core/data/models/cart_model.dart';

class ProductDetail extends StatefulWidget {
  final String productId;

  const ProductDetail({super.key, required this.productId});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(FetchProductDetail(widget.productId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductInitial || state is ProductLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ProductDetailLoaded) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const HeaderDesktop(),
                        ProductDetailContent(product: state.product),
                        if (state.relatedProducts != null &&
                            state.relatedProducts!.isNotEmpty)
                          RelatedProductsSection(
                              products: state.relatedProducts!),
                        const CustomFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is ProductError) {
          return Scaffold(
            body: Center(child: Text('Lỗi: ${state.errorMessage}')),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class ProductDetailContent extends StatefulWidget {
  final Product product;

  const ProductDetailContent({super.key, required this.product});

  @override
  _ProductDetailContentState createState() => _ProductDetailContentState();
}

class _ProductDetailContentState extends State<ProductDetailContent> {
  int _quantity = 1;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    context
        .read<ProductBloc>()
        .add(FetchRelatedProducts(widget.product.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 100),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    ProductImageCarousel(
                        images: [widget.product.imageUrl ?? '']),
                    const SizedBox(height: 16),
                    ThumbnailGallery(images: [widget.product.imageUrl ?? '']),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductInfo(product: widget.product),
                      const SizedBox(height: 24),
                      ProductActions(
                        product: widget.product,
                        quantity: _quantity,
                        onQuantityChanged: (quantity) =>
                            setState(() => _quantity = quantity),
                      ),
                      const SizedBox(height: 32),
                      const Divider(
                        color: CustomColor.primaryBlue,
                        thickness: 2,
                      ),
                      const SizedBox(height: 32),
                      ProductMetadata(product: widget.product),
                      const SizedBox(height: 32),
                      const ProductFeatures(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ProductTabs(
            product: widget.product,
            selectedTab: _selectedTab,
            onTabSelected: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
          ),
          const SizedBox(height: 32),
          RelatedProducts(productId: widget.product.id.toString()),
        ],
      ),
    );
  }
}

class ProductDescription extends StatelessWidget {
  final String description;

  const ProductDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mô tả sản phẩm',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class ProductImageCarousel extends StatelessWidget {
  final List<String> images;

  const ProductImageCarousel({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 560,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 1,
          viewportFraction: 1,
          enlargeCenterPage: true,
          autoPlay: false,
        ),
        items: images
            .map((imageUrl) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 60),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    width: 400,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class ThumbnailGallery extends StatelessWidget {
  final List<String> images;

  const ThumbnailGallery({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: images.map((imageUrl) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        );
      }).toList(),
    );
  }
}

class ProductInfo extends StatelessWidget {
  final Product product;

  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title ?? '',
          style: const TextStyle(
              fontSize: 24,
              color: CustomColor.secondBlue,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            RatingBarIndicator(
              rating: product.rating,
              itemBuilder: (context, index) =>
                  const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 20.0,
              direction: Axis.horizontal,
            ),
            const SizedBox(width: 8),
            Text(
              '(${product.rating} Customer Reviews)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          product.shortDescription ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        Text(
          '\$${product.price?.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: CustomColor.secondBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Stock Availability',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.green),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ProductActions extends StatelessWidget {
  Product product;
  int quantity;
  Function(int) onQuantityChanged;
  bool isProcessing = false;

  ProductActions({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        QuantitySelector(
          initialQuantity: quantity,
          onQuantityChanged: onQuantityChanged,
        ),
        const SizedBox(width: 19),
        SizedBox(
          width: 300,
          child: ElevatedButton.icon(
            onPressed: isProcessing
                ? null
                : () {
                    isProcessing = true;
                    final cartItem = CartItemModel(
                      id: product.id.toString(),
                      title: product.title ?? '',
                      author: product.author ?? '',
                      imageUrl: product.imageUrl ?? '',
                      price: product.price ?? 0,
                      quantity: 1,
                    );
                    context.read<CartBloc>().add(CartItemAdded(cartItem));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '${product.title} đã được thêm vào giỏ hàng')),
                    );
                    isProcessing = false;
                  },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Add To Cart'),
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColor.primaryBlue,
              iconColor: CustomColor.secondBlue,
              foregroundColor: CustomColor.secondBlue,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 19),
            ),
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton(
          onPressed: () {
            Beamer.of(context).beamToNamed(
              '/order/${product.id}?quantity=$quantity',
            );
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: CustomColor.secondBlue,
            side: const BorderSide(color: CustomColor.secondBlue, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          ),
          child: const Text('Mua ngay'),
        ),
        const SizedBox(width: 16),
        BlocListener<MyFavoriteProductBloc, MyFavoriteProductState>(
          listener: (context, state) {
            if (state is MyFavoriteProductActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product added to favorites!'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (state is MyFavoriteProductActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${state.error}')),
              );
            }
          },
          child: IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              context
                  .read<MyFavoriteProductBloc>()
                  .add(AddMyFavoriteProduct(product.id));
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.compare_arrows),
          onPressed: () {},
        ),
      ],
    );
  }
}

class ProductMetadata extends StatelessWidget {
  final Product product;

  const ProductMetadata({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: CustomColor.coolGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            MetadataRow(label: 'SKU', value: '${product.soldCount}'),
            MetadataRow(label: 'Tags', value: product.tags?.join(', ') ?? ''),
            MetadataRow(
                label: 'Publish Years',
                value: product.publicationDate?.toString() ?? ''),
            MetadataRow(label: 'Category', value: product.type ?? ''),
          ],
        ),
      ),
    );
  }
}

class MetadataRow extends StatelessWidget {
  final String label;
  final String value;

  const MetadataRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class ProductFeatures extends StatelessWidget {
  const ProductFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: CustomColor.coolGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      FeatureItem(
                        icon: Icons.local_shipping,
                        text: 'Free shipping orders from \$150',
                      ),
                      SizedBox(height: 16),
                      FeatureItem(
                        icon: Icons.refresh,
                        text: '30 days exchange & return',
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      FeatureItem(
                        icon: Icons.flash_on,
                        text: 'Mamaya Flash Discount: Starting at 30% Off',
                      ),
                      SizedBox(height: 16),
                      FeatureItem(
                        icon: Icons.security,
                        text: 'Safe & Secure online shopping',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: CustomColor.secondBlue),
          const SizedBox(width: 16),
          Expanded(
              child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final int initialQuantity;
  final Function(int) onQuantityChanged;

  const QuantitySelector({
    super.key,
    required this.initialQuantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.remove,
              size: 20,
            ),
            onPressed: () {
              if (initialQuantity > 1) {
                onQuantityChanged(initialQuantity - 1);
              }
            },
          ),
          Text(
            initialQuantity.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 20,
            ),
            onPressed: () {
              onQuantityChanged(initialQuantity + 1);
            },
          ),
        ],
      ),
    );
  }
}

class ProductTabs extends StatelessWidget {
  final Product product;
  final int selectedTab;
  final Function(int) onTabSelected;

  const ProductTabs({
    super.key,
    required this.product,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTabButton(context, 'Mô tả', 0),
            _buildTabButton(context, 'Thông tin bổ sung', 1),
            _buildTabButton(context, 'Đánh giá (3)', 2),
          ],
        ),
        const SizedBox(height: 20),
        _buildTabContent(),
      ],
    );
  }

  Widget _buildTabButton(BuildContext context, String title, int index) {
    return InkWell(
      onTap: () => onTabSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selectedTab == index
                  ? CustomColor.secondBlue
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Roboto',
            color: selectedTab == index ? CustomColor.secondBlue : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return ProductDescription(description: product.description ?? '');
      case 1:
        return ProductAdditionalInfo(product: product);
      case 2:
        return ProductReviews(productId: '${product.id}');
      default:
        return const SizedBox.shrink();
    }
  }
}

class ProductAdditionalInfo extends StatelessWidget {
  final Product product;

  const ProductAdditionalInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin bổ sung',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          children: [
            _buildTableRow('Tình trạng', '${product.soldCount}'),
            // _buildTableRow('Danh mục',
            //     product.tags 'Không có thông tin'),
            _buildTableRow('Ngày xuất bản', '${product.publicationDate}'),
            _buildTableRow('Tổng số trang', '${product.quantity}'),
            // _buildTableRow('Định dạng', product ?? 'Không có thông tin'),
            // _buildTableRow('Quốc gia', product.country ?? 'Không có thông tin'),
            // _buildTableRow(
            //     'Ngôn ngữ', product.language ?? 'Không có thông tin'),
            // _buildTableRow(
            //     'Kích thước', product.dimensions ?? 'Không có thông tin'),
            // _buildTableRow(
            //     'Trọng lượng', product.weight ?? 'Không có thông tin'),
          ],
        ),
      ],
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}

class ProductReviews extends StatelessWidget {
  final String productId;

  const ProductReviews({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Đánh giá cho sản phẩm $productId'),
        // Hiển thị danh sách đánh giá và form đánh giá ở đây
      ],
    );
  }
}

class RelatedProducts extends StatelessWidget {
  final String productId;

  const RelatedProducts({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is RelatedProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RelatedProductsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Sản phẩm liên quan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: state.relatedProducts
                    .map((product) =>
                        CardBook(product: product, isSimpleView: true))
                    .toList(),
              ),
            ],
          );
        } else if (state is RelatedProductsError) {
          return Center(child: Text('Lỗi: ${state.error}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class RelatedProductsSection extends StatelessWidget {
  final List<Product> products;

  const RelatedProductsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Sản phẩm liên quan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 800,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.65,
              ),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: CardBook(
                    product: product,
                    isSimpleView: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
