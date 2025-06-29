import 'package:book_app/core/domain/entity/book.dart';
import 'package:equatable/equatable.dart';

class BookPaging extends Equatable {
  final int counts;
  final String? next;
  final String? previous;
  final List<Book> books;

  const BookPaging({
    required this.counts,
    required this.next,
    required this.previous,
    required this.books
  });

  Map<String, dynamic> get toMap => {
    "count": counts,
    "next": next,
    "previous": previous,
    "results": books.map((e) => e.toMap).toList()
  };

  @override
  List<Object?> get props => [counts, next, previous, books];
}