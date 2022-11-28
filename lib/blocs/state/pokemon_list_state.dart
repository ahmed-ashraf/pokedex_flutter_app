import '../../screens/models/pokemon_details.dart';

abstract class PokemonListState {}

class LoadingPokemonListState extends PokemonListState {}

class NoInternetPokemonListState extends PokemonListState {}

class NoInternetLoadMorePokemonListState extends LoadMoreViewPokemonsListState {
  NoInternetLoadMorePokemonListState(super.list);
}

class FailedPokemonListState extends PokemonListState {}

class ViewPokemonsListState extends PokemonListState {
  List<PokemonDetails> list;

  ViewPokemonsListState(this.list);
}

class LoadMoreViewPokemonsListState extends ViewPokemonsListState {
  LoadMoreViewPokemonsListState(super.list);
}
