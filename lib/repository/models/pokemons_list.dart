import 'package:json_annotation/json_annotation.dart';
part 'pokemons_list.g.dart';

@JsonSerializable()
class PokemonsListRequest {
  int offset;
  int limit;

  PokemonsListRequest(this.offset, this.limit);

  Map<String, dynamic> toJson() => _$PokemonsListRequestToJson(this);
}

@JsonSerializable()
class PokemonsListResponse {
  dynamic count;
  List<PokemonDto>? results;

  PokemonsListResponse(this.count, this.results);

  factory PokemonsListResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonsListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonsListResponseToJson(this);
}

@JsonSerializable()
class PokemonDto {
  dynamic name;
  dynamic url;

  PokemonDto(this.name, this.url);

  factory PokemonDto.fromJson(Map<String, dynamic> json) =>
      _$PokemonDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonDtoToJson(this);
}
