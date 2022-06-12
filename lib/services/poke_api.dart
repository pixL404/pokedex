import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:pokedex/classes/generation.dart';
import 'package:pokedex/classes/pokemon_type.dart';

class PokeApi {
  static const _apiEndpoint = 'https://pokeapi.co/api/v2';

  static final _cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      cipher: null,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false);

  static final _dio = Dio()
    ..interceptors.add(DioCacheInterceptor(options: _cacheOptions));

  static getGenerations() async {}

  static loadSprite(String uri) async {}

  static getPokemonFromType(Type type) async {}

  static Future<Map<String, dynamic>?> loadPokemon(String identifier,
      {required bool absolute}) async {
    var uri = '';
    if (absolute) {
      uri = identifier;
    } else {
      uri = '$_apiEndpoint/pokemon/$identifier';
    }

    final resp = await _dio.get(uri);
    final status = resp.statusCode ?? -1;

    if (status != 200) {
      final message = resp.statusMessage ?? 'status message is null';
      log('loadPokemon GET $uri resulted in HTTP $status with reasoning $message');
      return null;
    }

    return resp.data;
  }

  static getPokemonFromGen(String generationName) async {}
}
