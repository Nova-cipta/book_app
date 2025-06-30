import 'dart:convert';
import 'dart:io';

import 'package:book_app/core/data/datasource/local/local_datasource.dart';
import 'package:book_app/core/data/model/book_model.dart';
import 'package:book_app/core/data/model/book_paging_model.dart';
import 'package:book_app/core/util/static.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'local_datasource_test.mocks.dart';

@GenerateMocks([Database, DatabaseExecutor, Transaction])
void main() {
  late MockDatabase mockDb;
  late LocalDatasourceImpl datasource;

  setUp(() {
    mockDb = MockDatabase();
    datasource = LocalDatasourceImpl(database: mockDb);
  });

  group('LocalDatasourceImpl', () {
    test('addLike should return true when update succeeds', () async {
      when(mockDb.update(
        any, any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs')
      )).thenAnswer((_) async => 1);

      final result = await datasource.addLike(id: 123);

      expect(result, isTrue);
      verify(mockDb.update(tbBooks, {'liked': 1}, where: 'id = ?', whereArgs: [123])).called(1);
    });

    test('removeLike should return false when update returns 0', () async {
      when(mockDb.update(any, any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
          .thenAnswer((_) async => 0);

      final result = await datasource.removeLike(id: 123);

      expect(result, isFalse);
      verify(mockDb.update(tbBooks, {'liked': 0}, where: 'id = ?', whereArgs: [123])).called(1);
    });

    test('saveBook inserts a new book when not exists', () async {
      final mockTxn = MockDatabaseExecutor();

      final file = File('assets/dummy_plain.json');
      final jsonString = await file.readAsString();
      final dummy =  BookPagingModel.fromJson(jsonDecode(jsonString));
      final dummyData = BookModel.fromJson(dummy.books.first.toMap);

      when(mockDb.transaction(any)).thenAnswer((invocation) async {
        return await invocation.positionalArguments[0](mockTxn);
      });

      when(
        mockTxn.query(
          tbBooks,
          columns: ['id'],
          where: 'id = ?',
          whereArgs: anyNamed('whereArgs'),
          limit: 1
        )
      ).thenAnswer((_) async => []);

      when(mockDb.transaction(any)).thenAnswer((_) async => dummyData);

      final result = await datasource.saveBook(data: dummyData.toMap);

      expect(result, equals(dummyData));
    });

    test('getSavedBook returns correct BookPagingModel with results', () async {
      final mockDb = MockDatabase();
      final mockTxn = MockTransaction();

      final file = File('assets/test_query_local_db.json');
      final jsonString = await file.readAsString();
      final dummySource =  BookPagingModel.fromJson(jsonDecode(jsonString));
      final dummyModel = dummySource.books.map((e) => BookModel.fromJson(e.toMap)).toList();

      final datasource = TestableLocalDatasource(
        database: mockDb,
        mockBooks: dummyModel,
      );

      when(mockDb.transaction<List<BookModel>>(any)).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments[0] as Future<List<BookModel>> Function(Transaction);
        return await callback(mockTxn);
      });

      when(mockTxn.rawQuery(any, any)).thenAnswer(
        (_) async => dummyModel.map((e) => {'id' : e.id}).toList()
      );

      final result = await datasource.getSavedBook(query: "", like: null, startIndex: 0);

      expect(result.books.length, dummyModel.length);
      expect(result.books[0].id, dummyModel[0].id);
      expect(result.books[1].id, dummyModel[1].id);
      expect(result.counts, 0);
      expect(result.next, "1");
      expect(result.previous, isNull);
    });
  });
}

class TestableLocalDatasource extends LocalDatasourceImpl {
  final List<BookModel> mockBooks;

  TestableLocalDatasource({
    required super.database,
    required this.mockBooks,
  });

  @override
  Future<BookModel> getBookModel({
    required DatabaseExecutor exec,
    required int id,
  }) async {
    return mockBooks.firstWhere((e) => e.id == id);
  }
}