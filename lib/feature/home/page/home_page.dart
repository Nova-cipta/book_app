import 'package:book_app/feature/home/provider/books_state.dart';
import 'package:book_app/feature/home/provider/home_provider.dart';
import 'package:book_app/feature/home/provider/liked_book_provider.dart';
import 'package:book_app/feature/home/provider/liked_books_state.dart';
import 'package:book_app/feature/home/widget/book_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

part '../widget/home_tab.dart';
part '../widget/like_tab.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/home";
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await context.read<HomeProvider>().initiateData();
      if (result is BooksFailure) {
        Fluttertoast.showToast(msg: result.failure.message);
      }
    });
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
      ),
    );
  }
}