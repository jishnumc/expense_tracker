import 'package:expense_tracker/src/app_ui/themes/app_theme_dark.dart';
import 'package:expense_tracker/src/app_ui/themes/app_theme_light.dart';
import 'package:expense_tracker/src/app_ui/typograhy/text_theme_native.dart';
import 'package:expense_tracker/src/router/app_router.dart';
import 'package:expense_tracker/src/system/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/src/system/di/injection.dart' as di;
import 'package:expense_tracker/src/system/di/injection.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:expense_tracker/src/outer_layer/notifications/notification_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await sl<INotificationClient>().initialize();
  Bloc.observer = TalkerBlocObserver(talker: talker);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const textTheme = TextThemeNative();
    return BlocProvider(
      create: (context) => sl<AuthBloc>()..add(const AuthEvent.checkStatusRequested()),
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
