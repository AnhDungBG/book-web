import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/author/author_bloc.dart';
import 'package:flutter_web_fe/blocs/author/author_event.dart';
import 'package:flutter_web_fe/blocs/category/category_bloc.dart';
import 'package:flutter_web_fe/blocs/category/category_event.dart';
import 'package:flutter_web_fe/blocs/category/category_state.dart';
import 'package:flutter_web_fe/blocs/search/book_search/book_search_bloc.dart';
import 'package:flutter_web_fe/blocs/search/book_search/book_search_event.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';

class FilterOption extends StatefulWidget {
  final Function(List<String>, List<String>, RangeValues) onFilterChanged;

  const FilterOption(
      {super.key,
      required this.onFilterChanged,
      required void Function(String query) onSearchChanged});

  @override
  // ignore: library_private_types_in_public_api
  _FilterOptionState createState() => _FilterOptionState();
}

class _FilterOptionState extends State<FilterOption> {
  List<String> _categories = [];

  final List<String> _selectedCategories = [];
  final List<String> _selectedAuthors = [];
  RangeValues _selectedPriceRange = const RangeValues(0, 100000);
  Timer? _debounce;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(FetchCategory());
    context.read<AuthorBloc>().add(FetchAuthor());
  }

  void _onCategorySelected(bool selected, String category) {
    setState(() {
      selected
          ? _selectedCategories.add(category)
          : _selectedCategories.remove(category);
      _applyFilters();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    context.read<SearchBloc>().add(PerformSearch(query: query));
  }

  void _applyFilters() {
    widget.onFilterChanged(
      _selectedCategories,
      _selectedAuthors,
      _selectedPriceRange,
    );
    if (_searchQuery.isNotEmpty) {
      _performSearch(_searchQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Search'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: SearchInputField(onChanged: _onSearchChanged),
        ),
        _buildSectionTitle('Categories'),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: _buildFilterCategory(),
        ),
        _buildSectionTitle('Filter By Price '),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _buildPriceRangeSlider(),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCategory() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoaded && state.categories.isNotEmpty) {
          _categories =
              state.categories.map((category) => category.ten).toList();
          return SizedBox(
            height: 280,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return CustomCategoryChip(
                    label: category,
                    isSelected: isSelected,
                    onSelected: (selected) =>
                        _onCategorySelected(selected, category),
                  );
                }).toList(),
              ),
            ),
          );
        } else if (state is CategoryError) {
          return const Center(child: Text('Không thể tải danh mục'));
        } else {
          return const Center(child: Text('Không tìm thấy danh mục'));
        }
      },
    );
  }

  Widget _buildPriceRangeSlider() {
    final List<double> pricePoints = [
      0,
      200000,
      400000,
      600000,
      800000,
      1000000
    ];

    String formatPrice(double price) {
      return '${price.toStringAsFixed(0)} đ';
    }

    _selectedPriceRange = RangeValues(
      _selectedPriceRange.start.clamp(pricePoints.first, pricePoints.last),
      _selectedPriceRange.end.clamp(pricePoints.first, pricePoints.last),
    );

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: const RectangularSliderValueIndicatorShape(),
            overlayShape: SliderComponentShape.noOverlay,
            valueIndicatorShape: const RectangularSliderValueIndicatorShape(),
            rangeThumbShape: const RectangularRangeSliderThumbShape(
              enabledThumbRadius: 6,
              elevation: 2,
            ),
            trackHeight: 3.0,
            activeTrackColor: CustomColor.secondBlue,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: CustomColor.secondBlue,
            valueIndicatorColor: CustomColor.secondBlue,
          ),
          child: RangeSlider(
            values: _selectedPriceRange,
            min: pricePoints.first,
            max: pricePoints.last,
            divisions: pricePoints.length - 1,
            labels: RangeLabels(
              formatPrice(_selectedPriceRange.start),
              formatPrice(_selectedPriceRange.end),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _selectedPriceRange = RangeValues(
                  _snapToNearestPrice(values.start, pricePoints),
                  _snapToNearestPrice(values.end, pricePoints),
                );
              });
              _applyFilters();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatPrice(_selectedPriceRange.start)),
              Text(formatPrice(_selectedPriceRange.end)),
            ],
          ),
        ),
      ],
    );
  }

  double _snapToNearestPrice(double value, List<double> pricePoints) {
    return pricePoints.reduce((a, b) {
      return (value - a).abs() < (value - b).abs() ? a : b;
    });
  }
}

class SearchInputField extends StatelessWidget {
  final Function(String) onChanged;

  const SearchInputField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: false,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 16, color: CustomColor.neutralGray),
      cursorColor: CustomColor.secondBlue,
      cursorWidth: 1.0,
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle:
            const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide:
              const BorderSide(color: CustomColor.neutralGray, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(color: CustomColor.coolGray, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }
}

class CustomCategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const CustomCategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? CustomColor.primaryBlue
                : const Color.fromARGB(153, 245, 245, 245),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: isSelected ? CustomColor.secondBlue : Colors.grey,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? CustomColor.secondBlue : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              isSelected ? const Icon(Icons.check) : Container(),
            ],
          )),
    );
  }
}

class RectangularRangeSliderThumbShape extends RangeSliderThumbShape {
  final double enabledThumbRadius;
  final double elevation;

  const RectangularRangeSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.elevation = 1.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    final rect = Rect.fromCenter(
      center: center,
      width: enabledThumbRadius * 1,
      height: enabledThumbRadius * 3,
    );

    final fillPaint = Paint()
      ..color = sliderTheme.thumbColor ?? CustomColor.neutralGray
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, fillPaint);

    if (elevation > 0) {
      canvas.drawShadow(
        Path()..addRect(rect),
        Colors.black,
        elevation,
        true,
      );
    }
  }
}
