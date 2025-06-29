import 'package:book_app/core/domain/entity/author.dart';

class AuthorModel extends Author {
  const AuthorModel({
    required super.name,
    required super.birthYear,
    required super.deathYear
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) => AuthorModel(
    name: json["name"],
    birthYear: int.tryParse(json["birth_year"].toString()) ?? 0,
    deathYear: int.tryParse(json["death_year"].toString()) ?? 0
  );
}