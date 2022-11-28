import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pokedex/helpers/dominant_color.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/repository/favourites_repository.dart';
import 'package:pokedex/screens/pokemon_details_page.dart';
import 'package:pokedex/screens/widgets/pokemon_list_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() {

  setUpAll(() async {
    await setupRepositories();

    GetIt.I.registerLazySingleton<DominantColor>(() => DominantColor());
  });

  group('Testing whole App', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    testWidgets('Scrolling test', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.pump(const Duration(seconds: 10));

      final listFinder = find.byKey(const Key('pokemonsList'));

      await binding.watchPerformance(() async {
        await tester.fling(listFinder, Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, Offset(0, -500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');
    });

    testWidgets('Testing pagination', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(seconds: 10));

      final listFinder = find.byKey(const Key('pokemonsList'));

      expect(find.byType(PokemonListItem, skipOffstage: false), findsNWidgets(10));
      await tester.fling(listFinder, Offset(0, -500), 10000);
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 5));

      expect(find.byType(PokemonListItem, skipOffstage: false), findsAtLeastNWidgets(11));
    });

    testWidgets('Testing add to favourites', (tester) async {
      await GetIt.I.get<FavouritesRepository>().clear();
      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(seconds: 10));

      await tester.tap(find.byType(PokemonListItem).first);
      await tester.pumpAndSettle();
      
      expect(find.byType(PokemonDetailsPage), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.pageBack();
      await tester.pumpAndSettle();

      final favCount = find.byKey(const Key('favCount'));
      expect(favCount, findsOneWidget);

      expect(find.descendant(of: favCount, matching: find.text('1')), findsOneWidget);

      await tester.tap(find.byKey(const Key('favouritesTap')));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(PokemonListItem), findsOneWidget);

      await GetIt.I.get<FavouritesRepository>().clear();
    });


    testWidgets('Testing remove from favourites', (tester) async {
      await GetIt.I.get<FavouritesRepository>().addToFavourites('https://pokeapi.co/api/v2/pokemon/1/');
      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(seconds: 10));

      await tester.tap(find.byType(PokemonListItem).first);
      await tester.pumpAndSettle();

      expect(find.byType(PokemonDetailsPage), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.pageBack();
      await tester.pumpAndSettle();

      final favCount = find.byKey(const Key('favCount'));
      expect(favCount, findsNothing);

      await tester.tap(find.byKey(const Key('favouritesTap')));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(PokemonListItem), findsNothing);

      final BuildContext context = tester.element(find.byType(Scaffold));
      expect(find.text(AppLocalizations.of(context)!.no_favourites), findsOneWidget);

      await GetIt.I.get<FavouritesRepository>().clear();
    });
  });
}
