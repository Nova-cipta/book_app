import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/feature/book_detail/provider/book_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TagsWidget extends StatelessWidget {
  final Book data;

  const TagsWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Selector<BookDetailProvider, bool>(
      selector: (_, provider) => provider.expTags,
      builder: (_, expanded, __) => AnimatedSize(
        duration: Duration(milliseconds: 200),
        curve: expanded ? Curves.easeInOut : Curves.easeOutExpo,
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: expanded
              ? BoxConstraints()
              : BoxConstraints(maxHeight: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              if (expanded) Text(
                "Subject",
                style: TextStyle(fontWeight: FontWeight.w300)
              ),
              if (expanded) Text.rich(
                TextSpan(
                  children: data.subjects.map((e) => WidgetSpan(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 4, right: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      color: Colors.black12, child: Text("#$e")
                    )
                  )).toList()
                ),
                softWrap: true
              ),
              if (expanded) Text(
                "Bookshelve",
                style: TextStyle(fontWeight: FontWeight.w300)
              ),
              if (expanded) Text.rich(
                TextSpan(
                  children: data.bookshelves.map((e) => WidgetSpan(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 4, right: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      color: Colors.black12, child: Text("#$e")
                    )
                  )).toList()
                ),
                softWrap: true
              )
            ]
          )
        )
      )
    );
  }
}