import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/blocs/favourites_cubit.dart';
import 'package:pokedex/blocs/state/favourites_state.dart';
import 'package:pokedex/helpers/dominant_color.dart';
import 'package:pokedex/screens/widgets/favourites_list.dart';
import 'package:pokedex/screens/widgets/pokemon_list_item.dart';

import '../../data/fake_pokemons.dart';
import '../../image_mock_http_client.dart';
import '../screen_creator.dart';

class MockFavouritesCubit extends MockCubit<FavouritesState>
    implements FavouritesCubit {}


class MockDominantColor extends Mock implements DominantColor {
  Future<Color> getColors(ImageProvider imageProvider) async {
    return Colors.white;
  }
}

late MockFavouritesCubit _listCubit;

void main() {
  setUpAll(() async {
    _listCubit = MockFavouritesCubit();
    registerFallbackValue(Uri());

    GetIt.I.registerLazySingleton<DominantColor>(() => MockDominantColor());

    final imageByteData =
    await rootBundle.load('../../assets/imgs/poke_img_sample.png');
    final imageIntList = imageByteData.buffer.asInt8List();

    final requestsMap = {
      Uri.parse(imageUrl1): imageIntList,
      Uri.parse(imageUrl2): imageIntList,
      Uri.parse(imageUrl3): imageIntList,
    };

    HttpOverrides.global = MockHttpOverrides(requestsMap);
  });

  group('Testing favourites list', () {
    testWidgets('Testing no internet connection state', (tester) async {
      whenListen(
          _listCubit,
          Stream.fromIterable(
              [LoadingFavouriteState(), NoInternetFavouritesState()]),
          initialState: LoadingFavouriteState());

      await tester.pumpWidget(createPokemonsListWidget());

      await tester.pump(const Duration(seconds: 1));

      final BuildContext context = tester.element(find.byType(Scaffold));
      expect(
          find.text(AppLocalizations.of(context)!.no_internet), findsOneWidget);
    });

    testWidgets('Testing viewing Pokemons list', (tester) async {
      whenListen(
          _listCubit,
          Stream.fromIterable([
            LoadingFavouriteState(),
            ViewFavouriteState(getViewPokemonsState())
          ]),
          initialState: LoadingFavouriteState());

      await tester.pumpWidget(createPokemonsListWidget());

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(PokemonListItem), findsNWidgets(3));
    });

    testWidgets('Testing general error', (tester) async {
      whenListen(
          _listCubit,
          Stream.fromIterable(
              [LoadingFavouriteState(), FailedFavouriteState()]),
          initialState: LoadingFavouriteState());

      await tester.pumpWidget(createPokemonsListWidget());

      await tester.pump(const Duration(seconds: 1));

      final BuildContext context = tester.element(find.byType(Scaffold));
      expect(find.text(AppLocalizations.of(context)!.error), findsOneWidget);
    });

    testWidgets('Testing no internet connection with list viewed state',
            (tester) async {
          whenListen(
              _listCubit,
              Stream.fromIterable([
                LoadingFavouriteState(),
                NoInternetLoadMoreFavouriteState(getViewPokemonsState())
              ]),
              initialState: LoadingFavouriteState());

          await tester.pumpWidget(createPokemonsListWidget());

          await tester.pump(const Duration(seconds: 1));

          final BuildContext context = tester.element(find.byType(Scaffold));
          expect(find.byType(PokemonListItem), findsNWidgets(3));
          expect(
              find.text(AppLocalizations.of(context)!.no_internet), findsOneWidget);
        });

    testWidgets('Testing no favourites state', (tester) async {
      whenListen(
          _listCubit,
          Stream.fromIterable(
              [LoadingFavouriteState(), NoFavouritesState()]),
          initialState: LoadingFavouriteState());

      await tester.pumpWidget(createPokemonsListWidget());

      await tester.pump(const Duration(seconds: 1));

      final BuildContext context = tester.element(find.byType(Scaffold));
      expect(
          find.text(AppLocalizations.of(context)!.no_favourites), findsOneWidget);
    });

    testWidgets('Testing pagination on scroll down', (tester) async {
      whenListen(_listCubit,
          Stream.fromIterable([ViewFavouriteState(getViewPokemonsState())]),
          initialState: ViewFavouriteState(getViewPokemonsState()));

      await tester.pumpWidget(createPokemonsListWidget());

      await tester.fling(
          find.byKey(const Key('favouritesList')), const Offset(0, -500), 10000);

      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.build,
        const Duration(minutes: 10),
      );

      verify(() => _listCubit.loadMore());
    });



  });
}

createPokemonsListWidget() {
  return createScreen(SafeArea(
    child: Scaffold(
      body: BlocProvider<FavouritesCubit>(
        create: (context) => _listCubit,
        child: const FavouritesList(),
      ),
    ),
  ));
}
