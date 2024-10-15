import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_event.dart';
import 'package:flutter_web_fe/blocs/product/product_sate.dart';
import 'package:flutter_web_fe/blocs/search/book_search/book_search_bloc.dart';
import 'package:flutter_web_fe/blocs/search/book_search/book_search_event.dart';
import 'package:flutter_web_fe/blocs/search/book_search/book_search_state.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/card_book.dart';
import 'package:flutter_web_fe/presentation/screens/products/components/skeleton_loading_card.dart';
import 'package:flutter_web_fe/presentation/screens/products/components/filter_options.dart';
import 'package:flutter_web_fe/presentation/components/header_desktop.dart';
import 'package:flutter_web_fe/presentation/components/wapper_mobile.dart';
import 'dart:async';

class ProductsPage extends StatefulWidget {
  final String? genreId;
  const ProductsPage({super.key, this.genreId});

  @override
  // ignore: library_private_types_in_public_api
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with AutomaticKeepAliveClientMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentPage = 1;
  final int _pageSize = 10;
  final String _searchQuery = '';
  List<String>? _selectedCategories;
  DateTime? _loadingStartTime;
  int _actualProductCount = 0;
  late SearchBloc _searchBloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.genreId != null) {
      _selectedCategories = [widget.genreId!];
    }
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    if (!BlocProvider.of<ProductBloc>(context).isClosed) {
      _fetchProducts();
    } else {
      print('ProductBloc đã bị đóng');
    }
  }

  void _fetchProducts({
    List<String>? categories,
    List<String>? authors,
    RangeValues? priceRange,
  }) {
    _loadingStartTime = DateTime.now();
    context.read<ProductBloc>().add(FetchProducts(
          page: _currentPage,
          limit: _pageSize,
          searchQuery: _searchQuery,
          categories: categories ?? _selectedCategories ?? [],
          authors: authors,
          priceRange: priceRange != null
              ? [priceRange.start, priceRange.end]
              : [0, 100000],
        ));
  }

  void _onFiltersChanged(List<String> selectedCategories,
      List<String> selectedAuthors, RangeValues priceRange) {
    setState(() {
      _currentPage = 1;
    });
    _fetchProducts(
      categories: selectedCategories,
      authors: selectedAuthors,
      priceRange: priceRange,
    );
  }

  void _onNextPage() {
    setState(() {
      _currentPage++;
    });
    _fetchProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchProducts();
  }

  void _onPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchProducts();
    }
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _searchBloc.add(ClearSearch());
      _fetchProducts();
    } else {
      _searchBloc.add(PerformSearch(query: query, page: 1, limit: _pageSize));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return BlocBuilder<SearchBloc, SearchState>(
          builder: (context, searchState) {
            return BlocBuilder<ProductBloc, ProductState>(
              builder: (context, productState) {
                final currentState =
                    searchState is SearchLoaded ? searchState : productState;

                if (currentState is ProductsLoaded ||
                    currentState is SearchLoaded) {
                  final products = currentState is ProductsLoaded
                      ? currentState.products
                      : (currentState as SearchLoaded).results;
                  _actualProductCount = products.length;
                }

                return Scaffold(
                  key: scaffoldKey,
                  endDrawer:
                      constraints.maxWidth >= 600 ? null : const DrawerMobile(),
                  body: Column(
                    children: [
                      const HeaderDesktop(),
                      Expanded(
                        child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 190, vertical: 0),
                            child: Column(
                              children: [
                                _buildResultsHeader(currentState),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (constraints.maxWidth >= 600)
                                        Expanded(
                                          flex: 1,
                                          child: FilterOption(
                                              onFilterChanged:
                                                  _onFiltersChanged,
                                              onSearchChanged:
                                                  _onSearchChanged),
                                        ),
                                      Expanded(
                                          flex: 4,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: _buildProductGrid(
                                                      currentState,
                                                      constraints),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildResultsHeader(dynamic state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: CustomColor.coolGray)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _buildResultsText(state),
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: CustomColor.neutralGray),
          ),
          DropdownButton<String>(
            value: 'Default Sorting',
            items: [
              'Default Sorting',
              'Price: Low to High',
              'Price: High to Low'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }

  String _buildResultsText(dynamic state) {
    if (state is ProductsLoaded || state is SearchLoaded) {
      final int startIndex = (_currentPage - 1) * _pageSize + 1;
      final num endIndex = startIndex + state.products.length - 1;
      final int totalResults = state.count ?? state.products.length;
      return 'Show $startIndex-$endIndex Of $totalResults Results';
    }
    return 'Loading...';
  }

  Widget _buildProductGrid(dynamic state, BoxConstraints constraints) {
    if (state is ProductLoading || state is SearchLoading) {
      return _buildSkeletonGrid();
    } else if (state is ProductsLoaded || state is SearchLoaded) {
      final products = state is ProductsLoaded ? state.products : state.results;
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _calculateCrossAxisCount(constraints.maxWidth),
          childAspectRatio: 0.63,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return CardBook(
            product: products[index],
            isSimpleView: true,
          );
        },
      );
    } else {
      return const Center(child: Text('Đã xảy ra lỗi'));
    }
  }

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) {
      return 5;
    } else if (screenWidth > 900) {
      return 4;
    } else if (screenWidth > 600) {
      return 3;
    } else {
      return 2;
    }
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            _calculateCrossAxisCount(MediaQuery.of(context).size.width),
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _actualProductCount > 0 ? _actualProductCount : _pageSize,
      itemBuilder: (context, index) => const ProductCardSkeleton(
        isSimpleView: true,
      ),
    );
  }

  Widget _buildPagination(ProductsLoaded state) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _currentPage > 1 ? _onPreviousPage : null,
            child: const Text('Trước'),
          ),
          const SizedBox(width: 10),
          Text('Trang $_currentPage'),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: state.products.length == _pageSize ? _onNextPage : null,
            child: const Text('Sau'),
          ),
        ],
      ),
    );
  }

  Future<void> _ensureMinimumLoadingTime() async {
    if (_loadingStartTime != null) {
      final elapsedTime = DateTime.now().difference(_loadingStartTime!);
      final remainingTime = const Duration(milliseconds: 400) - elapsedTime;
      if (remainingTime.isNegative) {
        return;
      } else {
        await Future.delayed(remainingTime);
      }
    }
  }
}
