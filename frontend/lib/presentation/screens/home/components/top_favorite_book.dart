import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/favoriteProduct/favorite_product_bloc.dart';
import 'package:flutter_web_fe/blocs/favoriteProduct/favorite_product_state.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';

class TopFavoriteBook extends StatefulWidget {
  const TopFavoriteBook({super.key});

  @override
  State<TopFavoriteBook> createState() => _TopFavoriteBookState();
}

class _TopFavoriteBookState extends State<TopFavoriteBook> {
  late final List<Product> _books = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteProductBloc, FavoriteProductState>(
      builder: (context, state) {
        print(context);
        if (state is FavoriteProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoriteProductsLoaded) {
          final books = state.favoriteProducts;
          if (books.isEmpty) {
            return const Center(child: Text('Không tìm thấy sách yêu thích.'));
          }
          return _buildBookGrid(books);
        } else if (state is FavoriteProductsError) {
          return Center(child: Text('Lỗi: ${state.error}'));
        }
        return const Center(child: Text('Không có dữ liệu sẵn sàng.'));
      },
    );
  }

  Widget _buildBookGrid(List<Product> books) {
    return Container(
      width: double.infinity,
      color: CustomColor.primaryBlue,
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 120, vertical: 30),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: CustomColor.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top favorite book  ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 5,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) => BookItem(book: books[index]),
              ),
            ],
          )),
    );
  }
}

class BookItem extends StatelessWidget {
  final Product book;

  const BookItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: CustomColor.coolGray.withOpacity(0.5),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildBookImage(),
              const SizedBox(width: 12),
              Expanded(
                // Sử dụng Expanded ở đây
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBookInfo(),
                    const SizedBox(height: 8),
                    _buildAuthorAndRating(),
                    const SizedBox(height: 8),
                    _buildAddToCartButton(),
                  ],
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookImage() {
    return SizedBox(
      child: book.imageUrl != null && book.imageUrl!.isNotEmpty
          ? Image.network(
              book.imageUrl!.startsWith('http')
                  ? book.imageUrl!
                  : 'http://localhost:99${book.imageUrl}', // Thêm domain nếu cần
              width: 80,
              height: 120,
              fit: BoxFit.cover,
            )
          : Container(
              width: 80,
              height: 120,
              color: Colors.grey, // Màu nền khi không có ảnh
            ),
    );
  }

  Widget _buildBookInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${book.title}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '\$${book.price?.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorAndRating() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 10,
          backgroundImage: NetworkImage('https://via.placeholder.com/20'),
        ),
        const SizedBox(width: 4),
        Text('${book.author}', style: const TextStyle(fontSize: 12)),
        const Spacer(),
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              index < book.rating ? Icons.star : Icons.star_border,
              size: 16,
              color: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.shopping_cart, size: 16),
      label: const Text('Add To Cart'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[100],
        foregroundColor: Colors.blue[800],
        minimumSize: const Size(double.infinity, 36),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.favorite_border, size: 20),
          onPressed: () {},
          color: Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 20),
          onPressed: () {},
          color: Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.visibility_outlined, size: 20),
          onPressed: () {},
          color: Colors.grey,
        ),
      ],
    );
  }
}
