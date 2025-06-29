import 'dart:developer';

import 'package:book_app/core/data/datasource/remote/remote_datasource.dart';
import 'package:book_app/core/data/datasource/local/local_datasource.dart';
import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/core/domain/entity/book_paging.dart';
import 'package:book_app/core/domain/repository/main_repository.dart';
import 'package:book_app/core/error/failure.dart';
import 'package:book_app/core/util/helper.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';

class MainRepositoryImpl implements MainRepository {
  final RemoteDatasource remote;
  final LocalDatasource local;

  MainRepositoryImpl({
    required this.remote,
    required this.local
  });

  @override
  Future<Either<Failure, BookPaging>> getList({String query = ""}) async {
    try {
      if (await connectionInfo()) {
        final result = await remote.getList(query: query);
        return Right(result);
      } else {
        return Left(ConnectionFailure(message: "No Connection"));
      }
    } on DioException catch (e) {
      log("DioException : ${e.message ?? e.error.toString()}", name: "MainRepositoryImpl.getList");
      return Left(ServerFailure(message: e.message ?? e.error.toString()));
    } catch (e) {
      log("message : $e", name: "MainRepositoryImpl.getList");
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getSavedBook({
    String query = "", bool? like, int startIndex = 1
  }) async {
    try {
      final result = await local.getSavedBook(query: query, like: like, startIndex: startIndex);
      return Right(result);
    } on DatabaseException catch (e) {
      log("DioException : ${e.result.toString()}", name: "MainRepositoryImpl.getSavedBook");
      return Left(ServerFailure(message: e.result.toString()));
    } catch (e) {
      log("message : $e", name: "MainRepositoryImpl.getSavedBook");
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Book>> saveBook({required Book data}) async {
    try {
      final result = await local.saveBook(data: data.toMap);
      return Right(result);
    } on DatabaseException catch (e) {
      log("DioException : ${e.result.toString()}", name: "MainRepositoryImpl.saveBook");
      return Left(ServerFailure(message: e.result.toString()));
    } catch (e) {
      log("message : $e", name: "MainRepositoryImpl.saveBook");
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> addLike({required int id}) async {
    try {
      final result = await local.addLike(id: id);
      return Right(result);
    } on DatabaseException catch (e) {
      log("DioException : ${e.result.toString()}", name: "MainRepositoryImpl.addLike");
      return Left(ServerFailure(message: e.result.toString()));
    } catch (e) {
      log("message : $e", name: "MainRepositoryImpl.addLike");
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeLike({required int id}) async {
    try {
      final result = await local.removeLike(id: id);
      return Right(result);
    } on DatabaseException catch (e) {
      log("DioException : ${e.result.toString()}", name: "MainRepositoryImpl.removeLike");
      return Left(ServerFailure(message: e.result.toString()));
    } catch (e) {
      log("message : $e", name: "MainRepositoryImpl.removeLike");
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}