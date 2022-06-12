import 'package:pokedex/classes/pokemon.dart';
import 'package:pokedex/services/poke_api.dart';

class Generation {
  final String name;
  final String uri;
  late List<Pokemon> _pokemon;

  Generation({
    required this.name,
    required this.uri,
  });

  Future<List<Pokemon>> get pokemon async {
    if (_pokemon.isEmpty) {
      _pokemon = await PokeApi.getPokemonFromGen(name);
    }

    return _pokemon;
  }
}
