import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/core/domain/repository/main_repository.dart';
import 'package:book_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class SaveBook<Type> {
  Future<Either<Failure, Book>> call({required Book data});
}

class SaveBookImpl implements SaveBook<Book> {
  final MainRepository repository;

  SaveBookImpl({required this.repository});

  @override
  Future<Either<Failure, Book>> call({required Book data}) async {
    return await repository.saveBook(data: data);
  }
}