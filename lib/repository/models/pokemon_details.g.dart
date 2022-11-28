// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PokemonDetailsResponse _$PokemonDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    PokemonDetailsResponse(
      json['id'],
      json['height'],
      json['weight'],
      json['name'],
      (json['stats'] as List<dynamic>)
          .map((e) => Stats.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['types'] as List<dynamic>)
          .map((e) => Types.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PokemonDetailsResponseToJson(
        PokemonDetailsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'height': instance.height,
      'weight': instance.weight,
      'name': instance.name,
      'stats': instance.stats,
      'types': instance.types,
    };

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
      json['base_stat'],
      json['effort'],
      Stat.fromJson(json['stat'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      'base_stat': instance.base_stat,
      'effort': instance.effort,
      'stat': instance.stat,
    };

Stat _$StatFromJson(Map<String, dynamic> json) => Stat(
      json['name'],
      json['url'],
    );

Map<String, dynamic> _$StatToJson(Stat instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };

Types _$TypesFromJson(Map<String, dynamic> json) => Types(
      json['slot'],
      Type.fromJson(json['type'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TypesToJson(Types instance) => <String, dynamic>{
      'slot': instance.slot,
      'type': instance.type,
    };

Type _$TypeFromJson(Map<String, dynamic> json) => Type(
      json['name'],
      json['url'],
    );

Map<String, dynamic> _$TypeToJson(Type instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };
