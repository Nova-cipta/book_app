import 'package:book_app/core/error/failure.dart';
import 'package:equatable/equatable.dart';

abstract class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object?> get props => [];
}

class BooksInitial extends BooksState{}

class BooksRefresh extends BooksState{}

class BooksLoading extends BooksState {}

class BooksLoaded extends BooksState {}

class BooksFailure extends BooksState {
  final Failure failure;

  const BooksFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}