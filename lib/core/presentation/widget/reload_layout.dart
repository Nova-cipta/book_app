import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReloadLayout extends StatelessWidget {
  final Function() onReload;
  final String message;
  final String textBtn;

  const ReloadLayout({
    super.key,
    required this.onReload,
    this.message = "",
    this.textBtn = "Reload"
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        if (message.isNotEmpty) Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text(message)
        ),
        FilledButton(
          onPressed: onReload,
          child: Text(textBtn)
        )
      ]
    );
  }
}