import 'package:equatable/equatable.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Product> results;
  final int totalResults;
  final bool hasReachedMax;

  const SearchLoaded({
    required this.results,
    required this.totalResults,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [results, totalResults, hasReachedMax];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
