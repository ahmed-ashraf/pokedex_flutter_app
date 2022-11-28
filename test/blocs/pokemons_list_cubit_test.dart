import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/blocs/pokemons_list_cubit.dart';
import 'package:pokedex/blocs/state/pokemon_list_state.dart';
import 'package:pokedex/network/errors/failure_entity.dart';
import 'package:pokedex/repository/models/pokemon_details.dart';
import 'package:pokedex/repository/models/pokemons_list.dart';
import 'package:pokedex/repository/pokemons_repository.dart';

import '../test_helpers/fixtures.dart';

class MockPokemonsRepository extends Mock implements PokemonsRepository {}

void main() {
  late MockPokemonsRepository mockPokemonsRepository = MockPokemonsRepository();

  setUpAll(() {
    registerFallbackValue(PokemonsListRequest(0, 10));
    GetIt.instance
        .registerSingleton<PokemonsRepository>(mockPokemonsRepository);
  });

  group('Testing PokemonList Cubit', () {
    blocTest<PokemonsListCubit, PokemonListState>(
      'Viewing list state',
      build: () {
        when(() => mockPokemonsRepository.getPokemons(any()))
            .thenAnswer((invocation) async {
          return Right(
              PokemonsListResponse.fromJson(getJsonFromFile('pokemons_list')));
        });

        when(() => mockPokemonsRepository.getPokemonDetails(any()))
            .thenAnswer((invocation) async {
          return Right(PokemonDetailsResponse.fromJson(
              getJsonFromFile('pokemon_details')));
        });
        return PokemonsListCubit();
      },
      act: (bloc) async {
        await bloc.loadData();
      },
      expect: () {
        return [isA<LoadingPokemonListState>(), isA<ViewPokemonsListState>()];
      },
    );

    blocTest<PokemonsListCubit, PokemonListState>(
      'Failed to get valid data',
      build: () {
        when(() => mockPokemonsRepository.getPokemons(any()))
            .thenAnswer((invocation) async {
          return Left(DataParsingException());
        });

        when(() => mockPokemonsRepository.getPokemonDetails(any()))
            .thenAnswer((invocation) async {
          return Right(PokemonDetailsResponse.fromJson(
              getJsonFromFile('pokemon_details')));
        });
        return PokemonsListCubit();
      },
      act: (bloc) async {
        await bloc.loadData();
      },
      expect: () {
        return [isA<LoadingPokemonListState>(), isA<FailedPokemonListState>()];
      },
    );

    blocTest<PokemonsListCubit, PokemonListState>(
      'No internet connection when getting list for the first time',
      build: () {
        when(() => mockPokemonsRepository.getPokemons(any()))
            .thenAnswer((invocation) async {
          return Left(NoConnectionException());
        });

        return PokemonsListCubit();
      },
      act: (bloc) async {
        await bloc.loadData();
      },
      expect: () {
        return [
          isA<LoadingPokemonListState>(),
          isA<NoInternetPokemonListState>()
        ];
      },
    );

    blocTest<PokemonsListCubit, PokemonListState>(
      'No internet connection when getting list for second page',
      build: () {
        List<Either<FailureEntity, PokemonsListResponse>> responses = [
          Right(
              PokemonsListResponse.fromJson(getJsonFromFile('pokemons_list'))),
          Left(NoConnectionException())
        ];
        when(() => mockPokemonsRepository.getPokemons(any()))
            .thenAnswer((invocation) async {
          return responses.removeAt(0);
        });

        when(() => mockPokemonsRepository.getPokemonDetails(any()))
            .thenAnswer((invocation) async {
          return Right(PokemonDetailsResponse.fromJson(
              getJsonFromFile('pokemon_details')));
        });

        return PokemonsListCubit();
      },
      act: (bloc) async {
        await bloc.loadData();
        await Future.delayed(const Duration(seconds: 1));
        await bloc.loadMore();
      },
      expect: () {
        return [
          isA<LoadingPokemonListState>(),
          isA<ViewPokemonsListState>(),
          isA<NoInternetLoadMorePokemonListState>()
        ];
      },
    );

    blocTest<PokemonsListCubit, PokemonListState>(
      'Failed to get valid pokemon details after getting Pokemons list',
      build: () {
        when(() => mockPokemonsRepository.getPokemons(any()))
            .thenAnswer((invocation) async {
          return Right(
              PokemonsListResponse.fromJson(getJsonFromFile('pokemons_list')));
        });

        when(() => mockPokemonsRepository.getPokemonDetails(any()))
            .thenAnswer((invocation) async {
          return Left(DataParsingException());
        });
        return PokemonsListCubit();
      },
      act: (bloc) async {
        await bloc.loadData();
      },
      expect: () {
        return [isA<LoadingPokemonListState>(), isA<FailedPokemonListState>()];
      },
    );
  });
}
