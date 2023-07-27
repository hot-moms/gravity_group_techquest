import 'package:flutter/material.dart';
import 'package:gravity_group_techquest/src/core/localization/app_localization.dart';
import 'package:gravity_group_techquest/src/feature/sample/sample_screen.dart';
import 'package:gravity_group_techquest/src/feature/settings/widget/settings_scope.dart';

/// {@template app}
/// App widget.
/// {@endtemplate}
class App extends StatefulWidget {
  /// {@macro app}
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Gravity Group Techquest',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalization.localizationsDelegates,

        /// Temporary solution cuz there's no external routing solution
        initialRoute: '/',
        routes: {
          '/': (_) => const MyHomePage(),
        },

        supportedLocales: AppLocalization.supportedLocales,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light(
            secondary: Colors.white,
            secondaryContainer: Color.fromARGB(255 * 80, 227, 239, 255),
            inverseSurface: Color(0xFFF0EDFF),
            primary: Color(0xFF0B55BB),
          ),
        ),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade900,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: const Color.fromARGB(255, 80, 151, 250),
            secondary: Colors.grey.shade800,
            secondaryContainer: Colors.grey.shade800,
            inverseSurface: Colors.transparent,
          ),
        ),
        themeMode: SettingsScope.themeOf(context),
        locale: View.of(context).platformDispatcher.locale,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child ?? const Placeholder(),
        ),
      );
}
