// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemons_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PokemonsListRequest _$PokemonsListRequestFromJson(Map<String, dynamic> json) =>
    PokemonsListRequest(
      json['offset'] as int,
      json['limit'] as int,
    );

Map<String, dynamic> _$PokemonsListRequestToJson(
        PokemonsListRequest instance) =>
    <String, dynamic>{
      'offset': instance.offset,
      'limit': instance.limit,
    };

PokemonsListResponse _$PokemonsListResponseFromJson(
        Map<String, dynamic> json) =>
    PokemonsListResponse(
      json['count'],
      (json['results'] as List<dynamic>?)
          ?.map((e) => PokemonDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PokemonsListResponseToJson(
        PokemonsListResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'results': instance.results,
    };

PokemonDto _$PokemonDtoFromJson(Map<String, dynamic> json) => PokemonDto(
      json['name'],
      json['url'],
    );

Map<String, dynamic> _$PokemonDtoToJson(PokemonDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };
