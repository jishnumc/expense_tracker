import 'package:expense_tracker/src/app_ui/themes/app_theme_dark.dart';
import 'package:expense_tracker/src/app_ui/themes/app_theme_light.dart';
import 'package:expense_tracker/src/app_ui/typograhy/text_theme_native.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/src/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/src/features/transaction/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/src/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/src/router/app_router.dart';
import 'package:expense_tracker/src/system/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expense_tracker/src/outer_layer/notifications/notification_client.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // Request permissions safely after the UI has fully mounted to the screen.
    // This avoids race conditions and ensures native OS dialogs appear correctly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<INotificationClient>().requestPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    const textTheme = TextThemeNative();
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<AuthBloc>()..add(const AuthEvent.checkStatusRequested()),
        ),
        BlocProvider(create: (context) => sl<TransactionBloc>()),
        BlocProvider(
          create: (context) =>
              sl<ProfileBloc>()..add(const ProfileEvent.fetched()),
        ),
        BlocProvider(
          create: (context) =>
              sl<CategoryBloc>()..add(const CategoryEvent.fetched()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        routerConfig: AppRouter.router,
        themeMode: ThemeMode.dark,
        theme: const AppThemeLight(textTheme).themeData,
        darkTheme: const AppThemeDark(textTheme).themeData,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
          Locale('fr'),
          Locale('de'),
          Locale('it'),
          Locale('ja'),
          Locale('ko'),
          Locale('zh'),
          Locale('pt'),
        ],
      ),
    );
  }
}
