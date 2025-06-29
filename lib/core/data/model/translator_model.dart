import 'package:book_app/core/domain/entity/translator.dart';

class TranslatorModel extends Translator {
  const TranslatorModel({
    required super.name,
    required super.birthYear,
    required super.deathYear
  });

  factory TranslatorModel.fromJson(Map<String, dynamic> json) => TranslatorModel(
    name: json["name"],
    birthYear: int.tryParse(json["birth_year"].toString()) ?? 0,
    deathYear: int.tryParse(json["death_year"].toString()) ?? 0
  );
}