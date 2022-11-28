import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/blocs/pokemon_mapper.dart';
import 'package:pokedex/blocs/state/favourites_state.dart';
import 'package:pokedex/repository/pokemons_repository.dart';

import '../network/errors/failure_entity.dart';
import '../repository/favourites_repository.dart';
import '../repository/models/pokemon_details.dart';
import '../screens/models/pokemon_details.dart';


class FavouritesCubit extends Cubit<FavouritesState> {
  FavouritesCubit() : super(LoadingFavouriteState());

  final FavouritesRepository _favouritesRepository = GetIt.I.get<FavouritesRepository>();
  final PokemonsRepository _pokemonsService = GetIt.I.get<PokemonsRepository>();

  int _page = 0;

  final Set<PokemonDetails> _list = {};

  loadData() async {
    _page = 0;
    _list.clear();
    emit(LoadingFavouriteState());
    List<String> urls = await _favouritesRepository.getPage(_page);

    if (urls.isEmpty) {
      emit(NoFavouritesState());
      return;
    }

    bool success = await loadPokemonsDetails(urls);
    if (success) emit(ViewFavouriteState(_list.toList()));
  }

  loadMore() async {
    List<String> urls = await _favouritesRepository.getPage(_page + 1);
    if (urls.isNotEmpty) {
      bool success = await loadPokemonsDetails(urls);
      if (success) {
        _page++;
        emit(LoadMoreViewFavouriteState(_list.toList()));
      }
    } else {
      emit(LoadMoreViewFavouriteState(_list.toList()));
    }
  }

  Future<bool> loadPokemonsDetails(List<String> list) async {
    bool error = false;
    List<PokemonDetails> myList = [];
    for (String url in list) {
      if (error) break;
      Either<FailureEntity, PokemonDetailsResponse> either = await _pokemonsService.getPokemonDetails(url);
      either.fold((l) {
        error = true;
        if (l is NoConnectionException) {
          emit(NoInternetFavouritesState());
        } else {
          emit(FailedFavouriteState());
        }
      }, (r) {
        PokemonDetails details = mapPokemonDetailsResponseToPokemonDetails(r);
        details.url = url;
        myList.add(details);
      });
    }
    if (!error) _list.addAll(myList);
    return !error;
  }
}