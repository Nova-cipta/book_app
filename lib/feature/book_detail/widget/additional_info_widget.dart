part of '../page/book_detail_page.dart';

class AdditionalInfoWidget extends StatelessWidget {
  final Book data;

  const AdditionalInfoWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Selector<BookDetailProvider, bool>(
      selector: (_, provider) => provider.expInfo,
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
            rowData(
              field: "Language",
              data: data.languages.join(", ")
            ),
            if (data.translators.isNotEmpty) Text(
              "Translator :",
              style: labelThin
            ),
            if (data.translators.isNotEmpty) Text(
              data.translators.map((e) => "\t\t\t\u2022\t${e.name}").join("\n"),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textMediumBold
            ),
            rowData(field: "Media Type", data: data.mediaType),
            rowData(field: "Downloaded", data: data.downloads.toString()),
            rowData(
              field: "Copyright",
              data: data.copyright != null ? " - " : data.copyright! ? "Yes" : "No"
            )
          ]
        ) : const SizedBox.shrink()
      )
    );
  }

  Widget rowData({
    required String field,
    required String data
  }) => Text.rich(
    TextSpan(
      children: [
        TextSpan(text: "$field : ", style: labelThin),
        TextSpan(text: data)
      ]
    )
  );
}