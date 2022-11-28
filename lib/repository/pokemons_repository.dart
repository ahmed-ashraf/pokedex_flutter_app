import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../network/api.dart';
import '../network/errors/failure_entity.dart';
import 'models/pokemon_details.dart';
import 'models/pokemons_list.dart';

class PokemonsRepository {
  Dio _dio;

  PokemonsRepository(this._dio);

  Future<Either<FailureEntity, PokemonsListResponse>> getPokemons(
      PokemonsListRequest request) async {
    try {
      Response<dynamic> response =
          await _dio.get(Api.getPokemon, queryParameters: request.toJson());
      return Right(PokemonsListResponse.fromJson(response.data));
    } on TypeError {
      return Left(DataParsingException());
    } on SocketException {
      return Left(NoConnectionException());
    } on DioError {
      return Left(NoConnectionException());
    }
  }

  Future<Either<FailureEntity, PokemonDetailsResponse>> getPokemonDetails(
      String url) async {
    try {
      Response<dynamic> response = await _dio.get(url);
      return Right(PokemonDetailsResponse.fromJson(response.data));
    } on TypeError {
      return Left(DataParsingException());
    } on SocketException {
      return Left(NoConnectionException());
    } on DioError {
      return Left(NoConnectionException());
    }
  }
}
