import 'package:flutter/material.dart';
import 'package:pokedex/classes/sprite.dart';
// import 'package:flutter/src/widgets/framework.dart';

class SpriteWidget extends StatelessWidget {
  final Sprite sprite;
  const SpriteWidget({super.key, required this.sprite});

  @override
  Widget build(BuildContext context) {
    return Image.network(sprite.uri);
  }
}
