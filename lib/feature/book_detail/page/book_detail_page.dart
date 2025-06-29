import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/core/util/injection.dart';
import 'package:book_app/feature/book_detail/provider/book_detail_provider.dart';
import 'package:book_app/feature/home/provider/liked_book_provider.dart';
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
      builder: (_, __) => PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            final likeProvider = context.read<LikedBookProvider>();
            if (detailProvider.liked == true) {
              likeProvider.addNewLiked = widget.data;
            } else if (detailProvider.liked == false) {
              likeProvider.removeLiked = widget.data.id;
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(elevation: 5, title: Text("Detail")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Container(
                  height: 20.h,
                  width: 100.w,
                  alignment: Alignment.center,
                  child: widget.data.formats.containsKey("image/jpeg") ? CachedNetworkImage(
                    imageUrl: widget.data.formats["image/jpeg"].toString(),
                    fit: BoxFit.contain,
                    errorWidget: (_, __, ___) => Icon(Icons.image, size: 20.h),
                    placeholder: (_, __) => Icon(Icons.image, size: 20.h)
                  ) : Icon(Icons.image, size: 20.h)
                ),
                rowData(field: "Title", data: widget.data.title),
                rowData(
                  field: widget.data.authors.length > 1 ? "Authors" : "Author",
                  data: widget.data.authors.map((e) => e.name).join("\n")
                ),
                rowData(field: "Summary", data: widget.data.summaries.join("\n\n")),
                if (widget.data.bookshelves.isNotEmpty) rowData(
                  field: widget.data.bookshelves.length > 1 ? "bookshelves" : "bookshelve",
                  data: widget.data.bookshelves.join("\n")
                ),
                if (widget.data.translators.isNotEmpty) rowData(
                  field: widget.data.translators.length > 1 ? "Translators" : "Translator",
                  data: widget.data.translators.map((e) => e.name).join("\n")
                ),
                if (widget.data.languages.isNotEmpty) rowData(
                  field: widget.data.languages.length > 1 ? "Languages" : "Language",
                  data: widget.data.languages.join("\n")
                ),
                rowData(field: "Media Type", data: widget.data.mediaType),
                rowData(field: "Downloaded", data: widget.data.downloads.toString()),
                rowData(
                  field: "Copyright",
                  data: widget.data.copyright != null
                    ? " - "
                    : widget.data.copyright! ? "Yes" : "No"
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
                color: liked == true ? Colors.red : null,
              )
            )
          )
        ),
      )
    );
  }

  Widget rowData({
    required String field,
    required String data
  }) =>Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text("$field : "),
        Expanded(child: Text(data))
      ]
    )
  );
}