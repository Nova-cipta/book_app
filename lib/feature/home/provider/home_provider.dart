import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/core/domain/usecase/get_books.dart';
import 'package:book_app/core/domain/usecase/get_favorite_books.dart';
import 'package:book_app/feature/home/provider/books_state.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  final GetBooks getBooks;
  final GetSavedBooks getSavedBooks;

  HomeProvider({
    required this.getBooks,
    required this.getSavedBooks
  });

  BooksState _booksState = BooksInitial();
  BooksState get bookState => _booksState;

  bool _offlineMode = false;
  bool get offlineMode => _offlineMode;
  set setOffline(bool val) {
    _offlineMode = val;
    notifyListeners();
  }

  List<Book> _listBook = [];
  List<Book> get listBook => _listBook;

  String _nextPage = "";
  int? _nextIndex;

  String _search = "";
  String get search => _search;
  String get searchParam => _search.isNotEmpty
      ? "search=${Uri.encodeComponent(_search)}" : "";

  Future<BooksState> refresh() async {
    if (_booksState is! BooksLoading && _booksState is! BooksRefresh) {
      _nextPage = "";
      _listBook = <Book>[];
      _booksState = BooksRefresh();
      notifyListeners();

      final result = await getBooks(query: searchParam);
      final state = await result.fold(
        (failure) async {
          final result = await getSavedBooks(query: search, startIndex: 0);
          return result.fold(
            (failure) => BooksFailure(failure: failure),
            (data) {
              _offlineMode = true;
              _listBook = data.books;
              _nextIndex = data.next != null ? int.tryParse(data.next!) : null;
              return BooksLoaded();
            }
          );
        },
        (data) async {
          _listBook = data.books;
          _nextPage = data.next ?? "";
          _offlineMode = false;
          return BooksLoaded();
        }
      );
      _booksState = state;
      notifyListeners();
      return state;
    } else {
      return _booksState;
    }
  }

  Future<BooksState> startSearch({required String search}) async {
    _search = search;
    return refresh();
  }

  Future<BooksState> scrollToNext() async {
    if (_booksState is! BooksLoading && _booksState is! BooksRefresh) {
      if (_offlineMode) {
        final next = _nextIndex;
        if (next != null) {
          _booksState = BooksLoading();
          notifyListeners();
          final state = await _scrollOffline(query: _search, startIndex: next);
          await Future.delayed(const Duration(milliseconds: 500));
          _booksState = state;
          notifyListeners();
          return state;
        }
      } else {
        if (_nextPage.isNotEmpty && _booksState is! BooksFailure) {
          _booksState = BooksLoading();
          notifyListeners();
          final state = await _scrollOnline(query: _nextPage);
          await Future.delayed(const Duration(milliseconds: 500));
          _booksState = state;
          notifyListeners();
          return state;
        }
      }
    }
    return _booksState;
  }

  Future<BooksState> _scrollOnline({
    required String query
  }) => getBooks(query: query).then((result) => result.fold(
    (failure) => BooksFailure(failure: failure),
    (data) {
      _listBook.addAll(data.books);
      _nextPage = data.next ?? "";
      return BooksLoaded();
    }
  ));

  Future<BooksState> _scrollOffline({
    required String query, required int startIndex
  }) => getSavedBooks(
    query: query, startIndex: startIndex
  ).then((result) => result.fold(
    (failure) => BooksFailure(failure: failure),
    (data) {
      if (data.books.isNotEmpty) {
        _listBook.addAll(data.books);
        _listBook.toSet().toList();
        _nextIndex = data.next != null ? int.tryParse(data.next!) : null;
      }
      return BooksLoaded();
    }
  ));
}