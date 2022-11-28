import '../../screens/models/pokemon_details.dart';

abstract class FavouritesState {}

class LoadingFavouriteState extends FavouritesState {}

class NoInternetFavouritesState extends FavouritesState {}

class NoFavouritesState extends FavouritesState {}

class NoInternetLoadMoreFavouriteState extends LoadMoreViewFavouriteState {
  NoInternetLoadMoreFavouriteState(super.list);
}

class FailedFavouriteState extends FavouritesState {}

class ViewFavouriteState extends FavouritesState {
  List<PokemonDetails> list;

  ViewFavouriteState(this.list);
}

class LoadMoreViewFavouriteState extends ViewFavouriteState {
  LoadMoreViewFavouriteState(super.list);
}
