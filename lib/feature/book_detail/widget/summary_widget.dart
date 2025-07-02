part of '../page/book_detail_page.dart';

class SummaryWidget extends StatelessWidget {
  final List<String> data;

  const SummaryWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Selector<BookDetailProvider, bool>(
      selector: (_, provider) => provider.expSummary,
      builder: (_, expanded, __) => AnimatedCrossFade(
        duration: Duration(milliseconds: 300),
        crossFadeState: expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        alignment: Alignment.topCenter,
        firstChild: Text.rich(
          TextSpan(
            children: data.map((e) => TextSpan(
              children: [
                WidgetSpan(child: SizedBox(width: 10)),
                TextSpan(text: e),
                if (data.indexOf(e) < data.length - 1) TextSpan(text: "\n")
              ]
            )).toList()
          ),
          maxLines: null,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.justify,
          softWrap: true,
        ),
        secondChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: data.map((e) => TextSpan(
                  children: [
                    WidgetSpan(child: SizedBox(width: 10)),
                    TextSpan(text: e),
                    if (data.indexOf(e) < data.length - 1) TextSpan(text: "\n")
                  ]
                )).toList()
              ),
              maxLines: 3,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.justify,
            ),
            InkWell(
              onTap: context.read<BookDetailProvider>().updExpSummary,
              child: Text("... see more", style: textButton.copyWith(fontSize: 14))
            )
          ]
        )
      )
    );
  }
}