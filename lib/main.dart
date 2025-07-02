import 'dart:developer';

import 'package:book_app/core/route/route.dart';
import 'package:book_app/core/util/color.dart';
import 'package:book_app/core/util/injection.dart';
import 'package:book_app/feature/home/page/home_page.dart';
import 'package:book_app/feature/home/provider/home_provider.dart';
import 'package:book_app/feature/home/provider/liked_book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await init();
    locator.isReady<Database>().then((value) {
      runApp(MyApp());
    });
  } on Exception catch (e) {
    log("message : $e", name: "main()");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, type) => MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeProvider>(
            create: (_) => locator<HomeProvider>()
          ),
          ChangeNotifierProvider<LikedBookProvider>(
            create: (_) => locator<LikedBookProvider>()
          )
        ],
        builder: (context, child) => MaterialApp(
          title: 'Books App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: seedColor,
              primary: primaryColor,
              secondary: secondaryColor,
              tertiary: tertiaryColor,
              surface: surfaceColor,
              error: errorColor,
            ),
            useMaterial3: false,
            scaffoldBackgroundColor: seedColor,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: surfaceColor,
              foregroundColor: primaryColor,
              iconSize: 30,
              shape: CircleBorder(),
            ),
            cardTheme: CardThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10.0)
              ),
              color: surfaceColor
            ),
          ),
          onGenerateRoute: generateRoute,
          initialRoute: HomePage.routeName,
        )
      )
    );
  }
}
