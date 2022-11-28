import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/blocs/favourites_cubit.dart';
import 'package:pokedex/blocs/state/favourites_state.dart';
import 'package:pokedex/network/errors/failure_entity.dart';
import 'package:pokedex/repository/favourites_repository.dart';
import 'package:pokedex/repository/models/pokemon_details.dart';
import 'package:pokedex/repository/models/pokemons_list.dart';
import 'package:pokedex/repository/pokemons_repository.dart';

import '../test_helpers/fixtures.dart';

class MockPokemonsRepository extends Mock implements PokemonsRepository {}

class MockFavouritesRepository extends Mock implements FavouritesRepository {}

late MockPokemonsRepository mockPokemonsRepository;
late MockFavouritesRepository favouritesRepository;

void main() {
  mockPokemonsRepository = MockPokemonsRepository();
  favouritesRepository = MockFavouritesRepository();

  setUpAll(() {
    registerFallbackValue(PokemonsListRequest(0, 10));
    GetIt.instance
        .registerSingleton<PokemonsRepository>(mockPokemonsRepository);
    GetIt.instance
        .registerSingleton<FavouritesRepository>(favouritesRepository);
  });

  group('Testing Favourites List Cubit', () {
    blocTest<FavouritesCubit, FavouritesState>(
      'Viewing list state',
      build: () {
        when(() => favouritesRepository.getPage(any()))
            .thenAnswer((invocation) async {
          return [
            'https://pokeapi.co/api/v2/pokemon/1/',
            'https://pokeapi.co/api/v2/pokemon/2/'
          ];
        });

        when(() => mockPokemonsRepository.getPokemonDetails(any()))
            .thenAnswer((invocation) async {
          return Right(PokemonDetailsResponse.fromJson(
              getJsonFromFile('pokemon_details')));
        });
        return FavouritesCubit();
      },
      act: (bloc) async {
        await bloc.loadData();
      },
      expect: () {
        return [isA<LoadingFavouriteState>(), isA<ViewFavouriteState>()];
      },
    );

    blocTest<FavouritesCubit, FavouritesState>(
      'No internet connection when getting list',
      build: () {
        when(() => favouritesRepository.getPage(any()))
            .thenAnswer((invocation) async {
          return [
            'https://pokeapi.co/api/v2/pokemon/1/',
            'https://pokeapi.co/api/v2/pokemon/2/'
          ];
        });

        when(() => mockPokemonsRepository.getPokemonDetails(any()))
            .thenAnswer((invocation) async {
          return Left(NoConnectionException());
        });
        return FavouritesCubit();
      },
      act: (bloc) async {
        await bloc.loadData();
      },
      expect: () {
        return [isA<LoadingFavouriteState>(), isA<NoInternetFavouritesState>()];
      },
    );

    blocTest<FavouritesCubit, FavouritesState>(
      'No favourites in the list',
      build: () {
        when(() => favouritesRepository.getPage(any()))
            .thenAnswer((invocation) async {
          return [];
        });
        return FavouritesCubit();
      },
      act: (bloc) async {
        await bloc.loadData();
      },
      expect: () {
        return [isA<LoadingFavouriteState>(), isA<NoFavouritesState>()];
      },
    );

    blocTest<FavouritesCubit, FavouritesState>(
      'Failed to get valid pokemon details after getting Pokemons list',
      build: () {
        when(() => favouritesRepository.getPage(any()))
            .thenAnswer((invocation) async {
          return [
            'https://pokeapi.co/api/v2/pokemon/1/',
            'https://pokeapi.co/api/v2/pokemon/2/'
          ];
        });

        when(() => mockPokemonsRepository.getPokemonDetails(any()))
            .thenAnswer((invocation) async {
          return Left(DataParsingException());
        });
        return FavouritesCubit();
      },
      act: (bloc) async {
        await bloc.loadData();
      },
      expect: () {
        return [isA<LoadingFavouriteState>(), isA<FailedFavouriteState>()];
      },
    );
  });
}
