// category_event.dart
import 'package:equatable/equatable.dart';

abstract class AuthorEvent extends Equatable {
  const AuthorEvent();

  @override
  List<Object> get props => [];
}

class FetchAuthor extends AuthorEvent {}
