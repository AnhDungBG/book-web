import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Don't forget to import Bloc!
import 'package:flutter_web_fe/blocs/topProduct/top_product_bloc.dart';
import 'package:flutter_web_fe/blocs/topProduct/top_product_event.dart';
import 'package:flutter_web_fe/blocs/topProduct/top_product_state.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/animated_button.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/card_book.dart';

class BookleTopBooks extends StatefulWidget {
  const BookleTopBooks({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookleTopBooksState createState() => _BookleTopBooksState();
}

class _BookleTopBooksState extends State<BookleTopBooks> {
  @override
  void initState() {
    super.initState();
    context.read<TopBookBloc>().add(const FetchTopBooks());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopBookBloc, TopBookState>(
      builder: (context, state) {
        if (state is TopBooksLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TopBooksLoaded) {
          final books = state.topBooks;
          if (books.isEmpty) {
            return const Center(child: Text('Không tìm thấy top sách.'));
          }
          return _buildContent(context, books); // Use the content builder
        } else if (state is TopBooksError) {
          return Center(child: Text('Lỗi: ${state.error}'));
        }
        return const Center(child: Text('Không có dữ liệu sẵn sàng.'));
      },
    );
  }

  Widget _buildContent(BuildContext context, List<Product> topBooks) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: _buildBookList(topBooks),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildFindYourNextBooks(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Bookle Top Books',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        CustomButton(
          title: 'Explore More',
          fontSize: 16,
          icon: Icons.arrow_forward,
        ),
      ],
    );
  }

  Widget _buildBookList(List<Product> topBooks) {
    return SizedBox(
      height: 500,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CardBook(product: topBooks[index], isSimpleView: false),
          );
        },
      ),
    );
  }

  Widget _buildFindYourNextBooks() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColor.primaryBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Find Your Next Books!',
            style: TextStyle(
              color: CustomColor.neutralGray,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'And Get Your 25% Discount Now!',
            style: TextStyle(color: CustomColor.neutralGray),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Beamer.of(context).beamToNamed('/products');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              foregroundColor: Colors.teal,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Shop Now →'),
          ),
          const SizedBox(
            height: 300,
            width: double.infinity,
            child: Image(
              image: AssetImage('assets/images/banner_image_lagre.png'),
            ),
          ),
        ],
      ),
    );
  }
}
