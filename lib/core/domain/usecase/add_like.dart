import 'package:book_app/core/domain/repository/main_repository.dart';
import 'package:book_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class AddLike<Type> {
  Future<Either<Failure, bool>> call({required int id});
}

class AddLikeImpl implements AddLike<bool> {
  final MainRepository repository;

  AddLikeImpl({required this.repository});

  @override
  Future<Either<Failure, bool>> call({required int id}) async {
    return await repository.addLike(id: id);
  }
}