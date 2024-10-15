import 'package:equatable/equatable.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductDetailLoaded extends ProductState {
  final Product product;
  final List<Product>? relatedProducts;

  const ProductDetailLoaded(this.product, {this.relatedProducts});

  @override
  List<Object?> get props => [product, relatedProducts];
}

class RelatedProductsLoaded extends ProductState {
  final List<Product> relatedProducts;

  const RelatedProductsLoaded(this.relatedProducts);

  @override
  List<Object> get props => [relatedProducts];
}

class ProductError extends ProductState {
  final String errorMessage;

  const ProductError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ProductSalesLoaded extends ProductState {
  final List<Product> productSales;
  const ProductSalesLoaded(this.productSales);

  @override
  List<Object?> get props => [productSales];
}

class AuthorProductsLoaded extends ProductState {
  final List<Product> authorProducts;

  const AuthorProductsLoaded(this.authorProducts);
  @override
  List<Object?> get props => [authorProducts];
}

class TagProductsLoading extends ProductState {}

class TagProductsLoaded extends ProductState {
  final List<Product> productTags;

  const TagProductsLoaded(this.productTags);
  @override
  List<Object?> get props => [productTags];
}

class AuthorProductsError extends ProductState {
  final String error;

  const AuthorProductsError(this.error);
  @override
  List<Object?> get props => [error];
}

class TagsProductsError extends ProductState {
  final String error;

  const TagsProductsError(this.error);
  @override
  List<Object?> get props => [error];
}

class ProductDetailError extends ProductState {
  final String error;

  const ProductDetailError(this.error);
  @override
  List<Object?> get props => [error];
}

class RelatedProductsLoading extends ProductState {}

class RelatedProductsError extends ProductState {
  final String error;

  const RelatedProductsError(this.error);

  @override
  List<Object?> get props => [error];
}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final int count;

  const ProductsLoaded(this.products, {required this.count});

  @override
  List<Object> get props => [products, count];
}

class AuthorProductsLoading extends ProductState {}

class ProductInit extends ProductState {}
