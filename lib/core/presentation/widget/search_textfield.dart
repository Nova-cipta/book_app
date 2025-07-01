import 'package:book_app/core/util/color.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String search) onSearch;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.onSearch
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTapOutside: (event) => primaryFocus?.unfocus(),
      onSubmitted: (value) {
        primaryFocus?.unfocus();
        onSearch(value);
      },
      decoration: InputDecoration(
        hintText: "Search",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        fillColor: surfaceColor,
        filled: true,
        isDense: true
      )
    );
  }
}