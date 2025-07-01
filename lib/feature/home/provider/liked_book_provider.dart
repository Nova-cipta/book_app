import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/core/domain/usecase/get_favorite_books.dart';
import 'package:flutter/material.dart';

import 'books_state.dart';

class LikedBookProvider with ChangeNotifier {
  final GetSavedBooks getSavedBooks;

  LikedBookProvider({required this.getSavedBooks});

  BooksState _likedState = BooksInitial();
  BooksState get likedState => _likedState;

  List<Book> _listLiked = [];
  List<Book> get listLiked => _listLiked;

  int? _next = 0;

  Future<BooksState> refresh() async {
    if (_likedState is! BooksLoading && _likedState is! BooksRefresh) {
      _next = 0;
      _likedState = BooksRefresh();
      notifyListeners();

      final result = await getSavedBooks(query: search, like: true, startIndex: 0);
      final state = result.fold(
        (failure) => BooksFailure(failure: failure),
        (data) {
          _listLiked = data.books;
          _next = data.next != null ? int.tryParse(data.next!) : null;
          return BooksLoaded();
        }
      );
      await Future.delayed(const Duration(milliseconds: 1000));
      _likedState = state;
      notifyListeners();
      return state;
    } else {
      return _likedState;
    }
  }

  String _search = "";
  String get search => _search;

  Future<BooksState> startSearch({required String search}) async {
    _search = search;
    return refresh();
  }

  Future<BooksState> fetchNextIndex() async {
    final next = _next;
    if (_likedState is! BooksLoading && _likedState is! BooksRefresh && next != null) {
      _likedState = BooksLoading();
      notifyListeners();

      final result = await getSavedBooks(
        query: search,
        like: true,
        startIndex: next
      );
      final state = result.fold(
        (failure) => BooksFailure(failure: failure),
        (data) {
          if (data.books.isNotEmpty) {
            _listLiked.addAll(data.books);
            _listLiked.toSet().toList();
            _next = data.next != null ? int.tryParse(data.next!) : null;
          }
          return BooksLoaded();
        }
      );
      await Future.delayed(const Duration(milliseconds: 1000));
      _likedState = BooksLoaded();
      notifyListeners();
      return state;
    } else {
      return _likedState;
    }
  }
}