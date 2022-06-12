import 'package:pokedex/services/poke_api.dart';

class Sprite {
  final String uri;
  final String name;
  late dynamic _image;

  Sprite({
    required this.uri,
    required this.name,
  });

  dynamic get image async {
    if (_image != null) {
      _image = await PokeApi.loadSprite(uri);
    }

    return _image;
  }
}
