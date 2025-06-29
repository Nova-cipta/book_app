import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/feature/book_detail/page/book_detail_page.dart';
import 'package:book_app/feature/home/page/home_page.dart';
import 'package:flutter/material.dart';

Route<Object?> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomePage.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const HomePage()
      );
    case BookDetailPage.routeName:
      final data = settings.arguments as Book;
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BookDetailPage(data: data)
      );
    default:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const Scaffold(
          body: Center(
              child: Text("Route Not Found")
          )
        )
      );
  }
}