import 'dart:convert';
import 'dart:developer';

import 'package:book_app/core/data/model/author_model.dart';
import 'package:book_app/core/data/model/book_model.dart';
import 'package:book_app/core/data/model/translator_model.dart';
import 'package:book_app/core/util/static.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDatasource {
  Future<BookModel> saveBook({required Map<String, Object?> data});
  Future<List<BookModel>> getSavedBook({String query = "", bool? like, int startIndex = 0});
  Future<bool> addLike({required int id});
  Future<bool> removeLike({required int id});
}

class LocalDatasourceImpl implements LocalDatasource {
  final Database database;

  LocalDatasourceImpl({required this.database});

  Future<void> _insertBookWithTransaction({
    required DatabaseExecutor exec,
    required Map<String, dynamic> bookData,
    required bool liked
  }) async {
    try {
      final id = bookData['id'];
      log("inserting : $id", name: "LocalDatasource._insertData");
      await exec.insert(tbBooks, {
        'id': id,
        'title': bookData['title'],
        'summaries' : json.encode(bookData['summaries']),
        'liked' : liked ? 1 : 0,
        'copyright': bookData['copyright'] != null
          ? bookData['copyright'] == true ? 1 : 0
          : -1,
        'media_type': bookData['media_type'],
        'formats' : json.encode(bookData['formats']),
        'download_count': bookData['download_count']
      });

      final languages = bookData['languages'] as List<String>;
      if (languages.isNotEmpty) {
        for (final lang in languages) {
          await exec.insert(tbLanguages, {'book_id': id, 'language': lang});
        }
      }

      final subjects = bookData['subjects'] as List<String>;
      if (subjects.isNotEmpty) {
        for (final subject in subjects) {
          await exec.insert(tbSubjects, {'book_id': id, 'subject': subject});
        }
      }

      final bookshelves = bookData['bookshelves'] as List<String>;
      if (bookshelves.isNotEmpty) {
        for (final shelf in bookshelves) {
          await exec.insert(tbBookshelves, {'book_id': id, 'shelf': shelf});
        }
      }

      final authors = bookData['authors'] as List<Map<String, dynamic>>;
      if (authors.isNotEmpty) {
        for (final author in authors) {
          final name = author['name'] as String;
          final birth = author['birth_year'] as int;
          final death = author['death_year'] as int;
          final oldData = await exec.query(
            tbAuthors,
            columns: ['id'],
            where: 'name = ? AND birth_year = ? AND death_year = ?',
            whereArgs: [name, birth, death],
            limit: 1,
          ).then((val) => val.map((e) => e['id'] as int).toList());
          final authorId = oldData.isEmpty ? await exec.insert(
            tbAuthors,
            {'name': name, 'birth_year' : birth, 'death_year' : death},
            conflictAlgorithm: ConflictAlgorithm.ignore
          ) : oldData.first;
          await exec.insert(tbBookAuthors, {'book_id': id, 'author_id': authorId});
        }
      }

      final translators = bookData['translators'] as List<Map<String, dynamic>>;
      if (translators.isNotEmpty) {
        for (final translator in translators) {
          final name = translator['name'] as String;
          final birth = translator['birth_year'] as int;
          final death = translator['death_year'] as int;
          final oldData = await exec.query(
            tbTranslators,
            columns: ['id'],
            where: 'name = ? AND birth_year = ? AND death_year = ?',
            whereArgs: [name, birth, death],
            limit: 1,
          ).then((val) => val.map((e) => e['id'] as int).toList());
          final translatorId = oldData.isEmpty ? await exec.insert(
            tbTranslators,
            {'name': name, 'birth_year' : birth, 'death_year' : death},
            conflictAlgorithm: ConflictAlgorithm.ignore
          ) : oldData.first;
          await exec.insert(tbBookTranslators, {
            'book_id': id,
            'translator_id': translatorId
          });
        }
      }
      log("finish inserting : $id", name: "LocalDatasource._insertData");
    } catch (e) {
      log("message : $e", name: "LocalDatasource._insertData");
      rethrow;
    }
  }

  Future<BookModel> _getBookModel({required DatabaseExecutor exec, required int id}) async {
    try {
      final book = await exec.query(
        tbBooks,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      ).then((val) => val.first);

      final summaries = json.decode(book['summaries'] as String) as List<dynamic>;

      final subjects = await exec.query(
        tbSubjects, columns: ['subject'], where: 'book_id = ?', whereArgs: [id]
      ).then((val) => val.isNotEmpty
        ? val.map<String>((e) => e['subject'].toString()).toList()
        : <String>[]
      );

      final bookshelves = await exec.query(
        tbBookshelves, columns: ['shelf'], where: 'book_id = ?', whereArgs: [id]
      ).then((val) => val.isNotEmpty
        ? val.map<String>((e) => e['shelf'].toString()).toList()
        : <String>[]
      );

      final languages = await exec.query(
        tbLanguages, columns: ['language'], where: 'book_id = ?', whereArgs: [id]
      ).then((val) => val.isNotEmpty
        ? val.map<String>((e) => e['language'].toString()).toList()
        : <String>[]
      );

      final authors = await exec.rawQuery(
        '''
          SELECT 
            a.name,
            a.birth_year,
            a.death_year
          FROM $tbAuthors a
          JOIN $tbBookAuthors ba ON a.id = ba.author_id
          WHERE ba.book_id = ?
        ''',
        [id]
      ).then((val) => val.isNotEmpty
        ? val.map((e) => AuthorModel.fromJson(e)).toList()
        : <AuthorModel>[]
      );

      final translators = await exec.rawQuery(
        '''
          SELECT 
            a.name,
            a.birth_year,
            a.death_year
          FROM $tbTranslators a
          JOIN $tbBookTranslators ba ON a.id = ba.translator_id
          WHERE ba.book_id = ?
        ''',
        [id]
      ).then((val) => val.isNotEmpty
        ? val.map((e) => TranslatorModel.fromJson(e)).toList()
        : <TranslatorModel>[]
      );

      return BookModel(
        id: id,
        title: book['title'].toString(),
        subjects: subjects,
        authors: authors,
        summaries: summaries.isNotEmpty
          ? summaries.map<String>((e) => e.toString()).toList() : <String>[],
        translators: translators,
        bookshelves: bookshelves,
        languages: languages,
        copyright: book['copyright'] == -1 ? null : book['copyright'] == 1,
        mediaType: book['media_type'].toString(),
        formats: jsonDecode(book['formats'].toString()),
        downloads: book['download_count'] as int,
        liked: book['liked'] == 1
      );
    } catch (e) {
      log("message : $e", name: "LocalDatasource._getBookModel");
      rethrow;
    }
  }

  @override
  Future<BookModel> saveBook({required Map<String, Object?> data}) async {
    try {
      final result = await database.transaction<BookModel>((txn) async {
        final id = data['id'] as int;

        final isExist = await txn.query(
          tbBooks, columns: ['id'], where: 'id = ?', whereArgs: [id], limit: 1
        ).then((result) => result.isNotEmpty);

        if (isExist) {
          return await _getBookModel(exec: txn, id: id);
        } else {
          await _insertBookWithTransaction(
            exec: txn, bookData: data, liked: false
          );
          return BookModel.fromJson(data);
        }
      });
      return result;
    } catch (e) {
      log("message : $e", name: "LocalDatasource.saveBook");
      rethrow;
    }
  }

  @override
  Future<List<BookModel>> getSavedBook({String query = "", bool? like, int startIndex = 0}) async {
    try {
      final keyword = '%$query%';
      final whereQuery = like != null
        ? query.isNotEmpty
          ? '''
              WHERE b.liked = ?
              AND (b.title LIKE ? OR a.name LIKE ?)
            '''
          : 'WHERE b.liked = ?'
        : query.isNotEmpty
          ? 'WHERE (b.title LIKE ? OR a.name LIKE ?)'
          : '';
      final whereArgs = [
        if (like != null) like ? 1 : 0,
        if (query.isNotEmpty) keyword,
        if (query.isNotEmpty) keyword,
        pagingSize,
        startIndex
      ];
      final result = await database.transaction<List<BookModel>>((txn) async {
        try {
          final listID = await txn.rawQuery(
            '''
              SELECT DISTINCT b.id
              FROM $tbBooks b
              LEFT JOIN $tbBookAuthors ba ON b.id = ba.book_id
              LEFT JOIN $tbAuthors a ON ba.author_id = a.id
              LEFT JOIN $tbBookTranslators bt ON b.id = bt.book_id
              LEFT JOIN $tbTranslators t ON bt.translator_id = t.id
              $whereQuery
              ORDER BY b.id ASC
              LIMIT ? OFFSET ?
            ''',
            whereArgs
          ).then((val) => val.map((e) => e['id'] as int).toList());
          final listBook = <BookModel>[];
          for (final id in listID) {
            try {
              final book = await _getBookModel(exec: txn, id: id);
              listBook.add(book);
            } catch (e) {
              continue;
            }
          }
          return listBook;
        } on Exception catch (e) {
          log("transaction : $e", name: "LocalDatasource.getSavedBook");
          rethrow;
        }
      });
      return result;
    } catch (e) {
      log("message : $e", name: "LocalDatasource.getSavedBook");
      rethrow;
    }
  }

  @override
  Future<bool> addLike({required int id}) async {
    try {
      final update = await database.update(
        tbBooks, {'liked' : 1}, where: 'id = ?', whereArgs: [id]
      );
      return update != 0;
    } catch (e) {
      log("message : $e", name: "LocalDatasource.addLike");
      rethrow;
    }
  }

  @override
  Future<bool> removeLike({required int id}) async {
    try {
      final result = await database.update(
        tbBooks, {'liked' : 0}, where: 'id = ?', whereArgs: [id]
      );
      return result != 0;
    } catch (e) {
      log("message : $e", name: "LocalDatasource.removeLike");
      rethrow;
    }
  }
}