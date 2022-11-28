import 'package:json_annotation/json_annotation.dart';

part 'pokemon_details.g.dart';

@JsonSerializable()
class PokemonDetailsResponse {
  dynamic id;
  dynamic height;
  dynamic weight;
  dynamic name;
  List<Stats> stats;
  List<Types> types;

  PokemonDetailsResponse(
      this.id, this.height, this.weight, this.name, this.stats, this.types);

  factory PokemonDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonDetailsResponseToJson(this);

}

@JsonSerializable()
class Stats {
  dynamic base_stat;
  dynamic effort;
  Stat stat;

  Stats(this.base_stat, this.effort, this.stat);

  factory Stats.fromJson(Map<String, dynamic> json) =>
      _$StatsFromJson(json);

  Map<String, dynamic> toJson() => _$StatsToJson(this);
}

@JsonSerializable()
class Stat {
  dynamic name;
  dynamic url;

  Stat(this.name, this.url);

  factory Stat.fromJson(Map<String, dynamic> json) =>
      _$StatFromJson(json);

  Map<String, dynamic> toJson() => _$StatToJson(this);
}

@JsonSerializable()
class Types {
  dynamic slot;
  Type type;

  Types(this.slot, this.type);

  factory Types.fromJson(Map<String, dynamic> json) =>
      _$TypesFromJson(json);

  Map<String, dynamic> toJson() => _$TypesToJson(this);
}

@JsonSerializable()
class Type {
  dynamic name, url;

  Type(this.name, this.url);

  factory Type.fromJson(Map<String, dynamic> json) =>
      _$TypeFromJson(json);

  Map<String, dynamic> toJson() => _$TypeToJson(this);
}
