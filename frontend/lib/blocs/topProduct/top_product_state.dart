import 'package:equatable/equatable.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';

abstract class TopBookState extends Equatable {
  const TopBookState();

  @override
  List<Object?> get props => [];
}

class TopBooksLoading extends TopBookState {}

class TopBooksLoaded extends TopBookState {
  final List<Product> topBooks;

  const TopBooksLoaded(this.topBooks);

  @override
  List<Object?> get props => [topBooks];
}

class TopBooksError extends TopBookState {
  final String error;

  const TopBooksError(this.error);

  @override
  List<Object?> get props => [error];
}
