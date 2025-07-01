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

  List<Book> _listBook = [];
  List<Book> get listBook => _listBook;

  String _nextPage = "";

  Future<BooksState> refresh() async {
    if (_booksState is! BooksLoading && _booksState is! BooksRefresh) {
      _nextPage = "";
      _booksState = BooksRefresh();
      notifyListeners();

      final result = await getBooks(query: searchParam);
      final state = result.fold(
        (failure) => BooksFailure(failure: failure),
        (data) {
          _listBook = data.books;
          _nextPage = data.next ?? "";
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

  String _search = "";
  String get search => _search;
  String get searchParam => _search.isNotEmpty
    ? "search=${Uri.encodeComponent(_search)}" : "";

  Future<BooksState> startSearch({required String search}) async {
    _search = search;
    return refresh();
  }

  Future<BooksState> fetchNextPage() async {
    if (_booksState is! BooksLoading && _booksState is! BooksRefresh && _nextPage.isNotEmpty
    ) {
      _booksState = BooksLoading();
      notifyListeners();

      final result = await getBooks(query: _nextPage);
      final state = result.fold(
        (failure) => BooksFailure(failure: failure),
        (data) {
          _listBook.addAll(data.books);
          _nextPage = data.next ?? "";
          return BooksLoaded();
        }
      );
      _booksState = BooksLoaded();
      notifyListeners();
      return state;
    } else {
      return _booksState;
    }
  }
}