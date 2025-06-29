import 'package:cached_network_image/cached_network_image.dart';
import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/feature/book_detail/page/book_detail_page.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book data;

  const BookCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        BookDetailPage.routeName, arguments: data
      ),
      child: Card(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                flex: 1,
                child: data.formats.containsKey("image/jpeg") ? CachedNetworkImage(
                  imageUrl: data.formats["image/jpeg"].toString(),
                  fit: BoxFit.contain,
                  errorWidget: (_, __, ___) => const Icon(Icons.image),
                  placeholder: (_, __) => const Icon(Icons.image)
                ) : const Icon(Icons.image)
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis
                    ),
                    Text(
                      data.authors.map((e) => e.name).join(" ; "),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis
                    )
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }
}