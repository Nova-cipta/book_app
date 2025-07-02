part of '../page/book_detail_page.dart';

class TagsWidget extends StatelessWidget {
  final Book data;

  const TagsWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Selector<BookDetailProvider, bool>(
      selector: (_, provider) => provider.expTags,
      builder: (_, expanded, __) => AnimatedSize(
        duration: Duration(milliseconds: 500),
        curve: expanded ? Curves.easeInOut : Curves.easeOutExpo,
        alignment: Alignment.topCenter,
        child: expanded ? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            const SizedBox.shrink(),
            Text("Subject", style: labelThin),
            Text.rich(
              TextSpan(
                children: data.subjects.map((e) => _buildTags(tag: e)).toList()
              ),
              softWrap: true
            ),
            Text("Bookshelve", style: labelThin),
            Text.rich(
              TextSpan(
                children: data.bookshelves.map((e) => _buildTags(tag: e)).toList()
              ),
              softWrap: true
            )
          ]
        ) : const SizedBox.shrink()
      )
    );
  }

  InlineSpan _buildTags({required String tag}) => WidgetSpan(
    child: Container(
      margin: const EdgeInsets.only(bottom: 4, right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      color: Colors.black12, child: Text("#$tag")
    )
  );
}