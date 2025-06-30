import 'dart:developer';

import 'package:book_app/core/data/model/book_paging_model.dart';
import 'package:dio/dio.dart';

/// contain all of the necessary API call used in this project
abstract class RemoteDatasource {
  /// get list of book from [baseUrl] API
  Future<BookPagingModel> getList({String query = ""});
}

class RemoteDatasourceImpl implements RemoteDatasource {
  final Dio dio;

  RemoteDatasourceImpl({required this.dio});

  @override
  Future<BookPagingModel> getList({String query = ""}) async {
    try {
      final param = query.isNotEmpty ? "?$query" : "";
      final result = await dio.get("books$param");
      return BookPagingModel.fromJson(result.data);
    } catch (e) {
      log("message : $e", name: "ApiDatasourceImpl.getList");
      rethrow;
    }
  }
}