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
  set addNewLiked(Book val) {
    if (!_listLiked.any((e) => e.id == val.id)) {
      _listLiked.add(val);
      notifyListeners();
    }
  }

  set removeLiked(int id) {
    if (_listLiked.any((e) => e.id == id)) {
      _listLiked.removeWhere((e) => e.id == id);
      notifyListeners();
    }
  }

  int _startIndex = 0;

  Future<LikedBooksState> refresh({String query = ""}) async {
    if (_likedState is! LikedBooksInitial || _likedState is! LikedBooksLoading) {
      _likedState = LikedBooksInitial();
      notifyListeners();

      final result = await getSavedBooks(query: query, like: true, startIndex: 0);
      final state = result.fold(
        (failure) => LikedBooksFailure(failure: failure),
        (data) {
          _listLiked = data;
          _startIndex = data.length;
          return _listLiked.isNotEmpty ? LikedBooksEmpty() : LikedBooksLoaded();
        }
      );
      _likedState = state;
      notifyListeners();
      return state;
    } else {
      return _likedState;
    }
  }

  Future<LikedBooksState> fetchNextIndex({required String query}) async {
    if (_likedState is! LikedBooksLoading /*&& _canNext*/) {
      _likedState = LikedBooksLoading();
      notifyListeners();

      final result = await getSavedBooks(
        query: query,
        like: true,
        startIndex: _startIndex
      );
      final state = result.fold(
        (failure) => LikedBooksFailure(failure: failure),
        (data) {
          if (data.isNotEmpty) {
            _listLiked.addAll(data);
            _listLiked.toSet().toList();
            _startIndex = data.length;
          }
          return LikedBooksLoaded();
        }
      );
      await Future.delayed(const Duration(milliseconds: 2000));
      _likedState = LikedBooksLoaded();
      notifyListeners();
      return state;
    } else {
      return _likedState;
    }
  }
}