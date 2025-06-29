import 'package:book_app/core/domain/entity/author.dart';
import 'package:book_app/core/domain/entity/translator.dart';
import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final int id;
  final String title;
  final List<String> subjects;
  final List<Author> authors;
  final List<String> summaries;
  final List<Translator> translators;
  final List<String> bookshelves;
  final List<String> languages;
  final bool? copyright;
  final String mediaType;
  final Map<String, Object?> formats;
  final int downloads;
  final bool liked;

  const Book({
    required this.id,
    required this.title,
    required this.subjects,
    required this.authors,
    required this.summaries,
    required this.translators,
    required this.bookshelves,
    required this.languages,
    required this.copyright,
    required this.mediaType,
    required this.formats,
    required this.downloads,
    required this.liked
  });

  Book setLike(bool val) => Book(
    id: id,
    title: title,
    subjects: subjects,
    authors: authors,
    summaries: summaries,
    translators: translators,
    bookshelves: bookshelves,
    languages: languages,
    copyright: copyright,
    mediaType: mediaType,
    formats: formats,
    downloads: downloads,
    liked: val
  );

  Map<String, dynamic> get toMap => {
    "id": id,
    "title": title,
    "subjects": subjects,
    "authors": authors.map((e) => e.toMap).toList(),
    "summaries": summaries,
    "translators": translators.map((e) => e.toMap).toList(),
    "bookshelves": bookshelves,
    "languages": languages,
    "copyright": copyright,
    "media_type": mediaType,
    "formats": formats,
    "download_count": downloads,
    "liked" : liked
  };

  @override
  List<Object?> get props => [
    id,
    title,
    subjects,
    authors,
    summaries,
    translators,
    bookshelves,
    languages,
    copyright,
    mediaType,
    formats,
    downloads,
    liked
  ];
}