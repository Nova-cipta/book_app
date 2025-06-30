import 'package:book_app/core/domain/entity/book_paging.dart';
import 'package:book_app/core/domain/repository/main_repository.dart';
import 'package:book_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class GetBooks<Type> {
  Future<Either<Failure, BookPaging>> call({String query = ""});
}

class GetBooksImpl implements GetBooks<BookPaging> {
  final MainRepository repository;

  GetBooksImpl({required this.repository});

  @override
  Future<Either<Failure, BookPaging>> call({String query = ""}) async {
    return await repository.getList(query: query);
  }
}