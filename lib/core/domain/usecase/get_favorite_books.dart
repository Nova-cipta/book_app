import 'package:book_app/core/domain/entity/book_paging.dart';
import 'package:book_app/core/domain/repository/main_repository.dart';
import 'package:book_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class GetSavedBooks<Type> {
  Future<Either<Failure, BookPaging>> call({
    String query = "", bool? like, int startIndex = 1
  });
}

class GetSavedBooksImpl implements GetSavedBooks<BookPaging> {
  final MainRepository repository;

  GetSavedBooksImpl({required this.repository});

  @override
  Future<Either<Failure, BookPaging>> call({
    String query = "", bool? like, int startIndex = 1
  }) async {
    return await repository.getSavedBook(query: query, like: like, startIndex: startIndex);
  }
}