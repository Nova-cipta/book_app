import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/core/util/color.dart';
import 'package:book_app/core/util/injection.dart';
import 'package:book_app/core/util/text_style.dart';
import 'package:book_app/feature/book_detail/provider/book_detail_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

part '../widget/additional_info_widget.dart';
part '../widget/summary_widget.dart';
part '../widget/tags_widget.dart';

class BookDetailPage extends StatefulWidget {
  static const String routeName = "/book_detail";
  final Book data;

  const BookDetailPage({super.key, required this.data});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final detailProvider = locator<BookDetailProvider>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => detailProvider..save(data: widget.data),
      builder: (_, __) => Scaffold(
        appBar: AppBar(elevation: 5, title: Text("Detail")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 20,
                children: [
                  widget.data.formats.containsKey("image/jpeg") ? CachedNetworkImage(
                    imageUrl: widget.data.formats["image/jpeg"].toString(),
                    fit: BoxFit.contain,
                    errorWidget: (_, __, ___) => Icon(Icons.image, size: 25.w),
                    placeholder: (_, __) => Icon(Icons.image, size: 25.w),
                    imageBuilder: (_, image) => Container(
                      constraints: BoxConstraints(minHeight: 15.h, maxWidth: 25.w),
                      alignment: Alignment.center,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: seedColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 2
                          )
                        ]
                      ),
                      child: Image(image: image)
                    )
                  ) : Icon(Icons.image, size: 25.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 7.5,
                      children: [
                        Text("Title", style: labelThin),
                        Text(widget.data.title, style: title),
                        const SizedBox.shrink(),
                        Text("Authors", style: labelThin),
                        Text(
                          widget.data.authors.isNotEmpty
                            ? widget.data.authors.map((e) => e.name).join("\n")
                            : "Unknown",
                          overflow: TextOverflow.ellipsis,
                          style: widget.data.authors.isNotEmpty
                            ? subTitle
                            : subTitle.copyWith(fontStyle: FontStyle.italic)
                        )
                      ]
                    )
                  )
                ]
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(thickness: 1, height: 1)
              ),
              Selector<BookDetailProvider, bool>(
                selector: (_, provider) => provider.expSummary,
                builder: (_, expanded, __) => _expandButton(
                  onTap: detailProvider.updExpSummary,
                  expanded: expanded,
                  text:  "Summary"
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SummaryWidget(data: widget.data.summaries),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(thickness: 1, height: 1)
              ),
              Selector<BookDetailProvider, bool>(
                selector: (_, provider) => provider.expTags,
                builder: (_, expanded, __) => _expandButton(
                  onTap: detailProvider.updExpTags,
                  expanded: expanded,
                  text: "Tags"
                )
              ),
              TagsWidget(data: widget.data),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(thickness: 1, height: 1)
              ),
              Selector<BookDetailProvider, bool>(
                selector: (_, provider) => provider.expInfo,
                builder: (_, expanded, __) => _expandButton(
                  onTap: detailProvider.updExpInfo,
                  expanded: expanded,
                  text: "Additional Info"
                )
              ),
              AdditionalInfoWidget(data: widget.data),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(thickness: 1, height: 1)
              ),
            ]
          )
        ),
        floatingActionButton: Selector<BookDetailProvider, bool?>(
          selector: (_, provider) => provider.liked,
          builder: (_, liked, __) => FloatingActionButton(
            onPressed: () async {
              if (liked != null) {
                final status = !liked;
                final success = await detailProvider.changeLike(data: widget.data, like: status);
                if (!success) {
                  Fluttertoast.showToast(msg: "Operation failed");
                }
              }
            },
            child: Icon(
              Icons.favorite,
              color: liked == true ? errorColor : null,
            )
          )
        )
      )
    );
  }

  Widget _expandButton({
    required Function() onTap,
    required String text,
    required bool expanded
  }) => InkWell(
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Text(text, style: textButton),
        Icon(expanded ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded)
      ]
    )
  );
}