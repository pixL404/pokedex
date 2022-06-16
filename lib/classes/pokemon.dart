import 'dart:developer';

import 'package:pokedex/classes/pokemon_type.dart';
import 'package:pokedex/classes/sprite.dart';
import 'package:pokedex/services/poke_api.dart';

class Pokemon {
  final int id;
  final String name;
  final int weight;
  final int height;
  final List<String> moves; //TODO: implement Move class
  final List<Sprite> sprites;
  final List<PokemonType> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.moves,
    required this.sprites,
    required this.types,
  });

  static Future<Pokemon?> fromURI(String uri) async {
    if (uri.isEmpty) {
      return null;
    }

    final resp = await PokeApi.loadSinglePokemon(uri, absolute: true);

    if (resp == null) {
      log('error retrieving pokemon from uri: $uri');
      return null;
    }

    return _createPokemon(resp);
  }

  static Future<Pokemon?> fromIdentifier(String identifier) async {
    if (identifier.isEmpty) {
      return null;
    }

    var resp = await PokeApi.loadSinglePokemon(identifier, absolute: false);

    if (resp == null) {
      log('error retrieving pokemon from identifier: $identifier');
      return null;
    }

    return _createPokemon(resp);
  }

  static Future<List<Pokemon?>> getBunch(int count, {int offset = 0}) async {
    var resp = await PokeApi.loadMultiplePokemon(count, offset);

    if (resp.isEmpty) {
      log('error retrieving $count Pokemon with offset=$offset');
      return List.empty();
    }

    var result = <Pokemon?>[];

    for (var x in resp) {
      result.add(await Pokemon.fromURI(x['url'] ?? ''));
    }

    return result;
  }

  static Pokemon _createPokemon(Map<String, dynamic> resp) {
    var sprites = resp['sprites']
      ..removeWhere(
          (key, value) => key == 'other' || key == 'versions' || value == null);
    sprites = sprites.entries.fold<List<Sprite>>(
      <Sprite>[],
      (prev, x) => List<Sprite>.of(prev)
        ..add(
          Sprite(
            name: x.key,
            uri: x.value,
          ),
        ),
    );

    final moves = resp['moves'].fold<List<String>>(
        <String>[], (prev, x) => List<String>.of(prev)..add(x['move']['name']));

    final types = resp['types'].fold<List<PokemonType>>(<PokemonType>[],
        (prev, x) => List<PokemonType>.of(prev)..add(PokemonType.fromJSON(x)));

    return Pokemon(
      id: resp['id'],
      name: resp['name'],
      height: resp['height'],
      weight: resp['weight'],
      moves: moves,
      sprites: sprites,
      types: types,
    );
  }
}
