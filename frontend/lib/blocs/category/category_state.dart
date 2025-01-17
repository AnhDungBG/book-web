import 'package:equatable/equatable.dart';
import 'package:flutter_web_fe/core/data/models/category_model.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Categories> categories;

  const CategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryError extends CategoryState {
  final String error;

  const CategoryError(this.error);

  @override
  List<Object?> get props => [error];
}
