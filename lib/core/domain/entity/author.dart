import 'package:equatable/equatable.dart';

class Author extends Equatable {
  final String name;
  final int birthYear;
  final int deathYear;

  const Author({
    required this.name,
    required this.birthYear,
    required this.deathYear
  });

  Map<String, dynamic> get toMap => {
    "name": name,
    "birth_year": birthYear,
    "death_year": deathYear
  };

  @override
  List<Object?> get props => [name, birthYear, deathYear];
}