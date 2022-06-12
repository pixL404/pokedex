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
    final resp = await PokeApi.loadPokemon(uri, absolute: true);

    if (resp == null) {
      log('error retrieving pokemon from uri: $uri');
      return null;
    }

    return _createPokemon(resp);
  }

  static Future<Pokemon?> fromIdentifier(String identifier) async {
    var resp = await PokeApi.loadPokemon(identifier, absolute: false);

    if (resp == null) {
      log('error retrieving pokemon from identifier: $identifier');
      return null;
    }

    return _createPokemon(resp);
  }

  static Pokemon _createPokemon(Map<String, dynamic> resp) {
    var sprites = resp['sprites']
      ..removeWhere(
          (key, value) => key == 'other' || key == 'versions' || value == null);
    sprites = sprites.entries.fold<List<Sprite>>(
      <Sprite>[],
      (prev, x) => List<Sprite>.from(prev)
        ..add(
          Sprite(
            name: x.key,
            uri: x.value,
          ),
        ),
    );

    // final List<String> moves = resp['moves']
    //     .map((x) => x['move']['name'].toString())
    //     .toList() as List<String>;

    final moves = resp['moves'].fold<List<String>>(<String>[],
        (prev, x) => List<String>.from(prev)..add(x['move']['name']));

    final types = resp['types'].fold<List<PokemonType>>(
        <PokemonType>[],
        (prev, x) =>
            List<PokemonType>.from(prev)..add(PokemonType.fromJSON(x)));

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
