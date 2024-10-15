import 'package:equatable/equatable.dart';
import 'package:flutter_web_fe/core/data/models/author_model.dart';

abstract class AuthorState extends Equatable {
  const AuthorState();

  @override
  List<Object?> get props => [];
}

class AuthorLoading extends AuthorState {}

class AuthorLoaded extends AuthorState {
  final List<Author> authors;

  const AuthorLoaded(this.authors);

  @override
  List<Object?> get props => [authors];
}

class AuthorError extends AuthorState {
  final String error;

  const AuthorError(this.error);

  @override
  List<Object?> get props => [error];
}
