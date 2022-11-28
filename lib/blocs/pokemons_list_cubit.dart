import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/blocs/pokemon_mapper.dart';
import 'package:pokedex/blocs/state/pokemon_list_state.dart';
import 'package:pokedex/repository/pokemons_repository.dart';
import 'package:pokedex/screens/models/pokemon_details.dart';

import '../network/errors/failure_entity.dart';
import '../repository/models/pokemon_details.dart';
import '../repository/models/pokemons_list.dart';


class PokemonsListCubit extends Cubit<PokemonListState> {
  PokemonsListCubit() : super(LoadingPokemonListState());

  int _page = 0;
  int _limit = 10;

  List<PokemonDetails> _list = [];

  final PokemonsRepository _pokemonsService = GetIt.I.get<PokemonsRepository>();

  loadData() async {
    _list.clear();
    _page = 0;
    emit(LoadingPokemonListState());

    Either<FailureEntity, PokemonsListResponse> either = await _pokemonsService
        .getPokemons(PokemonsListRequest(_page * _limit, _limit));

    either.fold((l) {
      if (l is NoConnectionException) {
        emit(NoInternetPokemonListState());
      } else {
        emit(FailedPokemonListState());
      }
    }, (r) async {
      bool success = await loadPokemonsDetails(r.results);
      if (success) emit(ViewPokemonsListState(_list));
    });
  }

  loadMore() async {
    Either<FailureEntity, PokemonsListResponse> either = await _pokemonsService
        .getPokemons(PokemonsListRequest((_page + 1) * _limit, _limit));

    either.fold((l) {
      if (l is NoConnectionException) {
        emit(NoInternetLoadMorePokemonListState(_list));
      }
    }, (r) async {
      bool success = await loadPokemonsDetails(r.results);
      if (success) {
        _page++;
        emit(LoadMoreViewPokemonsListState(_list));
      }
    });
  }

  Future<bool> loadPokemonsDetails(List<PokemonDto>? list) async {
    bool error = false;
    List<PokemonDetails> myList = [];
    for (PokemonDto dto in list ?? []) {
      if (error) break;
      Either<FailureEntity, PokemonDetailsResponse> either = await _pokemonsService.getPokemonDetails(dto.url);
      either.fold((l) {
        error = true;
        if (l is NoConnectionException) {
          emit(NoInternetPokemonListState());
        } else {
          emit(FailedPokemonListState());
        }
      }, (r) {
        PokemonDetails details = mapPokemonDetailsResponseToPokemonDetails(r);
        details.url = dto.url;
        myList.add(details);
      });
    }
    if (!error) _list.addAll(myList);
    return !error;
  }
}
