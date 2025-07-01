import 'package:book_app/feature/book_detail/provider/book_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SummaryWidget extends StatelessWidget {
  final List<String> data;

  const SummaryWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Selector<BookDetailProvider, bool>(
      selector: (_, provider) => provider.expSummary,
      builder: (_, expanded, __) => AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: expanded ? Curves.easeInOut : Curves.easeOutExpo,
        alignment: Alignment.topCenter,
        child: Text.rich(
          TextSpan(
            children: data.map((e) => TextSpan(
              children: [
                WidgetSpan(child: SizedBox(width: 10)),
                TextSpan(text: "$e\n")
              ]
            )).toList()
          ),
          maxLines: expanded ? null : 3,
          overflow: expanded ? null : TextOverflow.ellipsis,
          textAlign: TextAlign.justify,
        )
      )
    );
  }
}