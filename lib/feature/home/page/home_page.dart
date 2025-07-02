import 'package:book_app/core/presentation/widget/book_card.dart';
import 'package:book_app/core/presentation/widget/reload_layout.dart';
import 'package:book_app/core/presentation/widget/search_text_field.dart';
import 'package:book_app/core/util/color.dart';
import 'package:book_app/core/util/text_style.dart';
import 'package:book_app/feature/home/provider/books_state.dart';
import 'package:book_app/feature/home/provider/home_provider.dart';
import 'package:book_app/feature/home/provider/liked_book_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

part '../widget/home_tab.dart';
part '../widget/like_tab.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController tabCtrl;

  @override
  void initState() {
    tabCtrl = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Book App"),
          elevation: 5,
        ),
        resizeToAvoidBottomInset: true,
        body: TabBarView(
          controller: tabCtrl,
          children: [
            const HomeTab(),
            const LikeTab()
          ]
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: tabCtrl.index,
          onTap: (value) => setState(() => tabCtrl.animateTo(value)),
          items: [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home_rounded)
            ),
            BottomNavigationBarItem(
              label: "Likes",
              icon: Icon(Icons.favorite)
            )
          ]
        )
      )
    );
  }
}