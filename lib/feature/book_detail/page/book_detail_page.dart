import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/core/util/color.dart';
import 'package:book_app/core/util/injection.dart';
import 'package:book_app/feature/book_detail/provider/book_detail_provider.dart';
import 'package:book_app/feature/book_detail/widget/additional_info_widget.dart';
import 'package:book_app/feature/book_detail/widget/summary_widget.dart';
import 'package:book_app/feature/book_detail/widget/tags_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
            spacing: 10,
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
                        Text(
                          "Title",
                          style: TextStyle(fontWeight: FontWeight.w300)
                        ),
                        Text(
                          widget.data.title,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)
                        ),
                        const SizedBox.shrink(),
                        Text(
                          "Authors",
                          style: TextStyle(fontWeight: FontWeight.w300)
                        ),
                        Text(
                          widget.data.authors.isNotEmpty
                            ? widget.data.authors.map((e) => e.name).join("\n")
                            : "Unknown",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: widget.data.authors.isNotEmpty
                            ? TextStyle(fontSize: 14, fontWeight: FontWeight.w600)
                            : TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                        )
                      ]
                    )
                  )
                ]
              ),
              Divider(thickness: 1, height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Summary",
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300)
                  ),
                  GestureDetector(
                    onTap: detailProvider.updExpSummary,
                    child: Selector<BookDetailProvider, bool>(
                      selector: (_, provider) => provider.expSummary,
                      builder: (_, expanded, __) => Text(
                        "Show ${expanded ? "Less" : "More"}",
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  )
                ]
              ),
              SummaryWidget(data: widget.data.summaries),
              Divider(thickness: 1, height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tags", style: TextStyle(fontWeight: FontWeight.w300)),
                  GestureDetector(
                    onTap: detailProvider.updExpTags,
                    child: Selector<BookDetailProvider, bool>(
                      selector: (_, provider) => provider.expSummary,
                      builder: (_, expanded, __) => Text(
                        expanded ? "Hide" : "Show",
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.bold
                        )
                      )
                    )
                  )
                ]
              ),
              TagsWidget(data: widget.data),
              Divider(thickness: 1, height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Additional Info", style: TextStyle(fontWeight: FontWeight.w300)),
                  GestureDetector(
                    onTap: detailProvider.updExpInfo,
                    child: Selector<BookDetailProvider, bool>(
                      selector: (_, provider) => provider.expInfo,
                      builder: (_, expanded, __) => Text(
                        expanded ? "Hide" : "Show",
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.bold
                        )
                      )
                    )
                  )
                ]
              ),
              AdditionalInfoWidget(data: widget.data)
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
}