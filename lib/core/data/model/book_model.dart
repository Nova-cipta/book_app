import 'package:book_app/core/data/model/author_model.dart';
import 'package:book_app/core/data/model/translator_model.dart';
import 'package:book_app/core/domain/entity/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.subjects,
    required List<AuthorModel> super.authors,
    required super.summaries,
    required List<TranslatorModel> super.translators,
    required super.bookshelves,
    required super.languages,
    required super.copyright,
    required super.mediaType,
    required super.formats,
    required super.downloads,
    required super.liked
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    id: json["id"],
    title: json["title"],
    subjects: List<String>.from(
      json["subjects"].map((e) => e.toString())
    ).toList(),
    authors: List<AuthorModel>.from(
      json["authors"].map((e) => AuthorModel.fromJson(e))
    ).toList(),
    summaries: List<String>.from(
      json["summaries"].map((e) => e.toString())
    ).toList(),
    translators: List<TranslatorModel>.from(
      json["translators"].map((e) => TranslatorModel.fromJson(e))
    ).toList(),
    bookshelves: List<String>.from(
      json["bookshelves"].map((e) => e.toString())
    ).toList(),
    languages: List<String>.from(
      json["languages"].map((e) => e.toString())
    ).toList(),
    copyright: json["copyright"],
    mediaType: json["media_type"],
    formats: json["formats"],
    downloads: json["download_count"],
    liked: json.containsKey("liked") ? json["liked"] : false
  );
}