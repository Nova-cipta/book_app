import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/feature/book_detail/provider/book_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdditionalInfoWidget extends StatelessWidget {
  final Book data;

  const AdditionalInfoWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Selector<BookDetailProvider, bool>(
      selector: (_, provider) => provider.expInfo,
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
              if (expanded) Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Language : ",
                      style: TextStyle(fontWeight: FontWeight.w300)
                    ),
                    TextSpan(text: data.languages.join(", "))
                  ]
                )
              ),
              if (expanded && data.translators.isNotEmpty) Text(
                "Translator :",
                style: TextStyle(fontWeight: FontWeight.w300)
              ),
              if (expanded && data.translators.isNotEmpty) Text(
                data.authors.map((e) => "\t-\t${e.name}").join("\n"),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)
              ),
              if (expanded) rowData(
                field: "Media Type", data: data.mediaType
              ),
              if (expanded) rowData(
                field: "Downloaded", data: data.downloads.toString()
              ),
              if (expanded) rowData(
                field: "Copyright",
                data: data.copyright != null ? " - " : data.copyright! ? "Yes" : "No"
              )
            ]
          )
        )
      )
    );
  }

  Widget rowData({
    required String field,
    required String data
  }) => Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: "$field : ",
          style: TextStyle(fontWeight: FontWeight.w300)
        ),
        TextSpan(text: data)
      ]
    )
  );
}