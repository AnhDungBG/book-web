import 'package:equatable/equatable.dart';
import 'package:flutter_web_fe/core/data/models/genre_model.dart';

abstract class GenreState extends Equatable {
  const GenreState();

  @override
  List<Object> get props => [];
}

class GenreInitial extends GenreState {}

class GenreLoading extends GenreState {}

class GenreLoaded extends GenreState {
  final List<Genre> genres;

  const GenreLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}

class GenreError extends GenreState {
  final String message;

  const GenreError(this.message);

  @override
  List<Object> get props => [message];
}