import 'package:book_app/core/domain/repository/main_repository.dart';
import 'package:book_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class RemoveLike<Type> {
  Future<Either<Failure, bool>> call({required int id});
}

class RemoveLikeImpl implements RemoveLike<bool> {
  final MainRepository repository;

  RemoveLikeImpl({required this.repository});

  @override
  Future<Either<Failure, bool>> call({required int id}) async {
    return await repository.removeLike(id: id);
  }
}