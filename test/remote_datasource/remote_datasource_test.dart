import 'dart:convert';
import 'dart:io';

import 'package:book_app/core/data/datasource/remote/remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'remote_datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late RemoteDatasourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = RemoteDatasourceImpl(dio: mockDio);
  });

  group("RemoteDatasourceImpl.getList", () {
    test("returns BookPagingModel when the call completes successfully", () async {
      final file = File('assets/dummy_plain.json');
      final jsonString = await file.readAsString();
      final dummyData =  jsonDecode(jsonString);

      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: dummyData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await datasource.getList();

      expect(result.books.length, 32);
      expect(result.books.first.title, "Frankenstein; Or, The Modern Prometheus");
    });

    test("throws an exception when Dio throws", () async {
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: "Network error",
        type: DioExceptionType.unknown,
      ));

      expect(() async => await datasource.getList(), throwsException);
    });
  });
}
