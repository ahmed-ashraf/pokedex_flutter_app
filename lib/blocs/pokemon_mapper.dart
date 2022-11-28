import 'package:pokedex/helpers/capitalize.dart';
import 'package:pokedex/screens/models/pokemon_details.dart';

import '../network/api.dart';
import '../repository/models/pokemon_details.dart';

mapPokemonDetailsResponseToPokemonDetails(PokemonDetailsResponse details) =>
    PokemonDetails(details.id,
        name: details.name.toString().capitalize(),
        types: details.types.map((e) => e.type.name.toString().capitalize()).toList().join(', '),
        height: details.height,
        weight: details.weight,
        bmi: (details.weight / (details.height * details.height)),
        hp: details.stats[0].base_stat,
        attack: details.stats[1].base_stat,
        defense: details.stats[2].base_stat,
        specialAttach: details.stats[3].base_stat,
        specialDefense: details.stats[4].base_stat,
        speed: details.stats[5].base_stat,
        image: Api.getImageUrl(details.id.toString()));

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}