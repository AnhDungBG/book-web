import 'package:equatable/equatable.dart';

abstract class TopBookEvent extends Equatable {
  const TopBookEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopBooks extends TopBookEvent {
  const FetchTopBooks();
}
