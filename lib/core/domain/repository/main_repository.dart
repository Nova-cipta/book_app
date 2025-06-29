import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/core/domain/entity/book_paging.dart';
import 'package:book_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class MainRepository {
  Future<Either<Failure, BookPaging>> getList({String query = ""});
  Future<Either<Failure, List<Book>>> getSavedBook({
    String query = "", bool? like, int startIndex = 1
  });
  Future<Either<Failure, Book>> saveBook({required Book data});
  Future<Either<Failure, bool>> addLike({required int id});
  Future<Either<Failure, bool>> removeLike({required int id});
}