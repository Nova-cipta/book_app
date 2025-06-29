import 'package:book_app/core/error/failure.dart';
import 'package:equatable/equatable.dart';

abstract class LikedBooksState extends Equatable {
  const LikedBooksState();

  @override
  List<Object?> get props => [];
}

class LikedBooksInitial extends LikedBooksState{}

class LikedBooksLoading extends LikedBooksState {}

class LikedBooksEmpty extends LikedBooksState {}

class LikedBooksLoaded extends LikedBooksState {}

class LikedBooksFailure extends LikedBooksState {
  final Failure failure;

  const LikedBooksFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}