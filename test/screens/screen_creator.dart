import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';


class MockNavigatorObserver extends Mock implements NavigatorObserver {}

late MockNavigatorObserver mockObserver = MockNavigatorObserver();

Widget createScreen(Widget home) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
    onGenerateRoute: (RouteSettings settings) =>
        MaterialPageRoute(builder: (_) => const Scaffold()),
    navigatorObservers: [mockObserver],
  );
}