import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductEvent {
  final int page;
  final int limit;
  final List<String>? categories;
  final List<double>? priceRange;
  final List<String>? authors;
  final String? searchQuery;

  const FetchProducts({
    required this.page,
    required this.limit,
    this.categories,
    this.priceRange,
    this.authors,
    this.searchQuery,
  });

  @override
  List<Object?> get props =>
      [page, limit, categories, priceRange, authors, searchQuery];
}

class FetchProductDetail extends ProductEvent {
  final String productId;
  const FetchProductDetail(this.productId);
}

class FetchProductSales extends ProductEvent {
  const FetchProductSales();

  @override
  List<Object?> get props => [];
}

class FetchProductsByTags extends ProductEvent {
  final List<String> tags;

  const FetchProductsByTags(this.tags);
}

class FetchAuthorProducts extends ProductEvent {
  final String authorName;

  const FetchAuthorProducts(this.authorName);
}

class ResetProductState extends ProductEvent {
  const ResetProductState();
}

class FetchRelatedProducts extends ProductEvent {
  final String productId;

  const FetchRelatedProducts(this.productId);

  @override
  List<Object?> get props => [productId];
}
