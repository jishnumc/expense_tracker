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

class App extends StatelessWidget {
  const App({super.key});

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
      ),
    );
  }
}
