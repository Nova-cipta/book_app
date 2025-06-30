import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/core/domain/usecase/get_favorite_books.dart';
import 'package:book_app/feature/home/provider/liked_books_state.dart';
import 'package:flutter/material.dart';

class LikedBookProvider with ChangeNotifier {
  final GetSavedBooks getSavedBooks;

  LikedBookProvider({required this.getSavedBooks});

  LikedBooksState _likedState = LikedBooksInitial();
  LikedBooksState get likedState => _likedState;

  List<Book> _listLiked = [];
  List<Book> get listLiked => _listLiked;

  int? _next = 0;

  Future<LikedBooksState> refresh({String query = ""}) async {
    if (_likedState is! LikedBooksLoading && _likedState is! LikedBooksRefresh) {
      _next = 0;
      _likedState = LikedBooksRefresh();
      notifyListeners();

      final result = await getSavedBooks(query: query, like: true, startIndex: 0);
      final state = result.fold(
        (failure) => LikedBooksFailure(failure: failure),
        (data) {
          _listLiked = data.books;
          _next = data.next != null ? int.tryParse(data.next!) : null;
          return _listLiked.isNotEmpty ? LikedBooksEmpty() : LikedBooksLoaded();
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

  Future<LikedBooksState> fetchNextIndex({required String query}) async {
    final next = _next;
    if (_likedState is! LikedBooksLoading && _likedState is! LikedBooksRefresh && next != null) {
      _likedState = LikedBooksLoading();
      notifyListeners();

      final result = await getSavedBooks(
        query: query,
        like: true,
        startIndex: next
      );
      final state = result.fold(
        (failure) => LikedBooksFailure(failure: failure),
        (data) {
          if (data.books.isNotEmpty) {
            _listLiked.addAll(data.books);
            _listLiked.toSet().toList();
            _next = data.next != null ? int.tryParse(data.next!) : null;
          }
          return LikedBooksLoaded();
        }
      );
      await Future.delayed(const Duration(milliseconds: 1000));
      _likedState = LikedBooksLoaded();
      notifyListeners();
      return state;
    } else {
      return _likedState;
    }
  }
}