import 'dart:async';
import 'dart:developer';

import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/core/domain/usecase/add_like.dart';
import 'package:book_app/core/domain/usecase/remove_like.dart';
import 'package:book_app/core/domain/usecase/save_book.dart';
import 'package:flutter/material.dart';

class BookDetailProvider with ChangeNotifier {
  final AddLike addLike;
  final SaveBook saveBook;
  final RemoveLike removeLike;

  BookDetailProvider({
    required this.addLike,
    required this.saveBook,
    required this.removeLike
  });

  bool _expSummary = true;
  bool get expSummary => _expSummary;
  updExpSummary() {
    _expSummary = !_expSummary;
    notifyListeners();
  }

  bool _expTags = false;
  bool get expTags => _expTags;
  updExpTags() {
    _expTags = !_expTags;
    notifyListeners();
  }

  bool _expInfo = false;
  bool get expInfo => _expInfo;
  updExpInfo() {
    _expInfo = !_expInfo;
    notifyListeners();
  }

  Completer<bool> _isSaved = Completer<bool>();

  Future<void> save({required Book data}) async {
    final result = await saveBook(data: data);
    result.fold(
      (failure) {
        log("message : $failure", name: "BookDetailProvider.save");
        setLiked = false;
        _isSaved.complete(false);
      },
      (data) {
        setLiked = data.liked;
        _isSaved.complete(true);
      }
    );
  }

  bool? _liked = false;
  bool? get liked => _liked;
  set setLiked(bool? val) {
    if (_liked != val) {
      _liked = val;
      notifyListeners();
    }
  }

  Future<bool> changeLike({required Book data, required bool like}) async {
    setLiked = null;

    final isSaved = await _isSaved.future;
    if (!isSaved) {
      _isSaved = Completer<bool>();
      notifyListeners();
      await save(data: data);
    }

    final result = like
      ? await addLike(id: data.id)
      : await removeLike(id: data.id);

    return result.fold(
      (failure) {
        setLiked = !like;
        return false;
      },
      (success) {
        setLiked = like;
        return success;
      }
    );
  }
}