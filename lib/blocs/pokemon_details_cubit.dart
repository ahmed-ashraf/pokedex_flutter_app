import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../repository/favourites_repository.dart';
import 'state/pokemon_details_state.dart';

class PokemonDetailsCubit extends Cubit<PokemonDetailsState> {
  PokemonDetailsCubit() : super(InitPokemonDetailsState());

  final FavouritesRepository _favouritesRepository = GetIt.I.get<FavouritesRepository>();

  Future addToFavourites(String url) async {
    emit(InitPokemonDetailsState());
    await _favouritesRepository.addToFavourites(url);
    emit(IsFavouritePokemonDetailsState());
  }

  isFavourite(String url) async {
    bool val = await _favouritesRepository.isFavourite(url);
    if (val) {
      emit(IsFavouritePokemonDetailsState());
    } else {
      emit(IsNotFavouritePokemonDetailsState());
    }
  }

  Future removeFavourite(String url) async {
    emit(InitPokemonDetailsState());
    await _favouritesRepository.removeFromFavourites(url);
    emit(IsNotFavouritePokemonDetailsState());
  }
}