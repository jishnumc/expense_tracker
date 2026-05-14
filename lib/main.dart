import 'package:expense_tracker/src/app_ui/themes/app_theme_dark.dart';
import 'package:expense_tracker/src/app_ui/themes/app_theme_light.dart';
import 'package:expense_tracker/src/app_ui/typograhy/text_theme_native.dart';
import 'package:expense_tracker/src/router/router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const textTheme = TextThemeNative();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      routerConfig: AppRouter.router,
      themeMode: ThemeMode.dark,
      theme: const AppThemeLight(textTheme).themeData,
      darkTheme: const AppThemeDark(textTheme).themeData,
    );
  }
}
