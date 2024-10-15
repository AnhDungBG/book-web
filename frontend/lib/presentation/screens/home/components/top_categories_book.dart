import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/genre/genre_bloc.dart';
import 'package:flutter_web_fe/blocs/genre/genre_state.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';
import 'package:flutter_web_fe/core/data/models/genre_model.dart';
import 'package:beamer/beamer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TopCategoryBook extends StatelessWidget {
  const TopCategoryBook({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenreBloc, GenreState>(
      builder: (context, state) {
        if (state is GenreLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GenreLoaded) {
          return _buildGenreCarousel(context, state.genres);
        } else if (state is GenreError) {
          return Center(child: Text('Lỗi: ${state.message}'));
        }
        return _buildGenreCarousel(context, _getFakeGenres());
      },
    );
  }

  List<Genre> _getFakeGenres() {
    return [
      Genre(
          id: 1,
          name: 'Tiểu thuyết',
          bookCount: 100,
          imageUrl: 'https://picsum.photos/200/300?random=1'),
      Genre(
          id: 2,
          name: 'Khoa học viễn tưởng',
          bookCount: 80,
          imageUrl: 'https://picsum.photos/200/300?random=2'),
      Genre(
          id: 3,
          name: 'Lịch sử',
          bookCount: 60,
          imageUrl: 'https://picsum.photos/200/300?random=3'),
    ];
  }

  Widget _buildGenreCarousel(BuildContext context, List<Genre> genres) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
      margin: const EdgeInsets.symmetric(vertical: 50),
      width: double.infinity,
      color: CustomColor.primaryBlue,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              border: Border.all(color: CustomColor.coolGray, width: 3),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 360,
                    viewportFraction: 0.2,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                  ),
                  items: genres.map((genre) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CarouselItem(
                          imageUrl: genre.imageUrl ??
                              'https://picsum.photos/200/300?random=1',
                          title: genre.name,
                          bookCount: genre.bookCount ?? 0,
                          onTap: () => _navigateToProductList(context, genre),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: CustomColor.primaryBlue,
              child: const Text(
                "Top Categories Book",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 71, 85, 102),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _navigateToProductList(BuildContext context, Genre genre) {
    context.beamToNamed('/products', data: {'genreId': genre.id.toString()});
  }
}

class CarouselItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int bookCount;
  final VoidCallback onTap;

  const CarouselItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.bookCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                  color: CustomColor.white,
                  border: Border.all(width: 1, color: CustomColor.coolGray),
                  borderRadius: const BorderRadius.all(Radius.circular(200))),
              child: SizedBox(
                width: 100,
                height: 150,
                child: Image.network(
                  'https://picsum.photos/200/300?random=1',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColor.secondBlue,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '$bookCount books',
              style: TextStyle(
                fontSize: 14,
                color: CustomColor.secondBlue.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
