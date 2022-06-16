import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokedex/classes/pokemon.dart';
import 'package:pokedex/components/sprite_widget.dart';

class PokemonWidget extends StatefulWidget {
  final Pokemon pokemon;
  final int spriteChangeInterval;

  const PokemonWidget({
    Key? key,
    required this.pokemon,
    this.spriteChangeInterval = 5,
  }) : super(key: key);

  @override
  State<PokemonWidget> createState() => _PokemonWidgetState();
}

class _PokemonWidgetState extends State<PokemonWidget> {
  int _currentSprite = 0;
  late final List<SpriteWidget> _sprites;

  @override
  void initState() {
    super.initState();

    Timer.periodic(
      Duration(seconds: widget.spriteChangeInterval),
      _interval,
    );

    _sprites = widget.pokemon.sprites.fold<List<SpriteWidget>>(
      <SpriteWidget>[],
      (prev, x) => List<SpriteWidget>.of(prev)
        ..add(
          SpriteWidget(sprite: x),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
        tag: 'Sprite#$_currentSprite',
        child: _sprites[_currentSprite],
      ),
      onTap: () =>
          log('tapped ${widget.pokemon.name} on sprite #$_currentSprite'),
    );
  }

  void _interval(Timer timer) {
    setState(() {
      _currentSprite = widget.pokemon.sprites.length != _currentSprite + 1
          ? _currentSprite + 1
          : 0;
    });
  }
}
