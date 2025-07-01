import 'package:cached_network_image/cached_network_image.dart';
import 'package:book_app/core/domain/entity/book.dart';
import 'package:book_app/feature/book_detail/page/book_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: const EdgeInsets.all(5),
          constraints: BoxConstraints(minHeight: 15.h),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                flex: 1,
                child: data.formats.containsKey("image/jpeg") ? CachedNetworkImage(
                  imageUrl: data.formats["image/jpeg"].toString(),
                  fit: BoxFit.contain,
                  errorWidget: (_, __, ___) => const Icon(Icons.image),
                  placeholder: (_, __) => const Icon(Icons.image),
                  imageBuilder: (context, image) => Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusGeometry.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(1.5, 1.5),
                          blurRadius: 1
                        )
                      ]
                    ),
                    child: Image(image: image),
                  )
                ) : const Icon(Icons.image)
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 7,
                  children: [
                    Text(
                      "Title:",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300)
                    ),
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)
                    ),
                    const SizedBox.shrink(),
                    Text(
                      "Authors:",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300)
                    ),
                    Text(
                      data.authors.isNotEmpty
                        ? data.authors.map((e) => e.name).join(" ; ")
                        : "Unknown",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: data.authors.isNotEmpty
                        ? TextStyle(fontSize: 14, fontWeight: FontWeight.w600)
                        : TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
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