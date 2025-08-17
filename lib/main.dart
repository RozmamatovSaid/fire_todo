import 'package:fire_todo/core/injection/dp_injection.dart';
import 'package:fire_todo/core/provider/bloc_observer.dart';
import 'package:fire_todo/core/provider/providers.dart';
import 'package:fire_todo/core/router/router.dart';
import 'package:fire_todo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('uz'), Locale('ru')],
      path: 'assets/i18n',
      fallbackLocale: const Locale('uz'),
      startLocale: const Locale('ru'),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: Providers.bloc,
      child: MaterialApp.router(
        title: "FIRE TODO",
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: CustomTheme.theme,
      ),
    );
  }
}
