import 'package:book_app/core/data/model/book_model.dart';
import 'package:book_app/core/domain/entity/book_paging.dart';

class BookPagingModel extends BookPaging {
  const BookPagingModel({
    required super.counts,
    required super.next,
    required super.previous,
    required List<BookModel> super.books
  });

  factory BookPagingModel.fromJson(Map<String, dynamic> json) => BookPagingModel(
    counts: json["count"],
    next: json["next"] != null
      ? Uri.parse(json["next"].toString()).query
      : null,
    previous: json["previous"] != null
      ? Uri.parse(json["previous"].toString()).query
      : null,
    books: List<BookModel>.from(
      json["results"].map((e) => BookModel.fromJson(e))
    ).toList()
  );
}