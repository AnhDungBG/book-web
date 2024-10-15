import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class PerformSearch extends SearchEvent {
  final String query;
  final int page;
  final int limit;

  const PerformSearch({
    required this.query,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [query, page, limit];
}

class ClearSearch extends SearchEvent {}
