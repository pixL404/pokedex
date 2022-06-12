import 'package:pokedex/classes/pokemon.dart';
import 'package:pokedex/services/poke_api.dart';

enum Type {
  normal,
  fighting,
  flying,
  poison,
  ground,
  rock,
  bug,
  ghost,
  steel,
  fire,
  water,
  grass,
  electric,
  psychic,
  ice,
  dragon,
  dark,
  fairy,
  unknown,
  shadow,
}

class PokemonType {
  final Type type;
  final int position;

  PokemonType({
    required this.type,
    required this.position,
  });

  factory PokemonType.fromJSON(Map<String, dynamic> parsed) {
    final parsedType = parsed['type']['name'].toString().toLowerCase();
    return PokemonType(
      type: Type.values
          .firstWhere((x) => x.toString().toLowerCase() == 'type.$parsedType'),
      position: parsed['slot'] as int,
    );
  }

  Future<List<Pokemon>> get getPokemon async {
    var resp = await PokeApi.getPokemonFromType(type);
    return resp;
  }
}
