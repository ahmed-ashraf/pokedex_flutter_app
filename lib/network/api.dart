import 'dart:io';

Map<String, String> headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

class Api {

  static const String apiUrl = 'https://pokeapi.co/api/v2/';
  static const String getPokemon = '${apiUrl}pokemon/';

  static String getImageUrl(String id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }
}