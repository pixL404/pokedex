import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokedex/classes/pokemon.dart';
import 'package:pokedex/components/pokemon_widget.dart';

class HomeScreen extends StatefulWidget {
  final int loadSizeInterval;
  const HomeScreen({super.key, this.loadSizeInterval = 25});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Pokemon?> _pokemon;
  late ScrollController _controller;

  int _offset = 0;
  bool _loadedMaxItems = false;

  @override
  void initState() {
    super.initState();

    _pokemon = <Pokemon?>[];
    populate(widget.loadSizeInterval);

    _controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pokemon.isEmpty
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : GridView.builder(
              itemCount: _pokemon.length,
              controller: _controller,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width / 4,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) => Card(
                child: _pokemon[index] != null
                    ? PokemonWidget(pokemon: _pokemon[index]!)
                    : const Icon(Icons.error_outline),
              ),
            ),
    );
  }

  Future<bool> populate(int count, {int offset = 0}) async {
    var temp = <Pokemon?>[];
    temp.addAll(await Pokemon.getBunch(count, offset: offset));

    if (temp.isEmpty) {
      return false;
    } else {
      setState(() {
        _pokemon.addAll(temp);
      });

      return true;
    }
  }

  void _scrollListener() async {
    if (_loadedMaxItems) {
      return;
    }

    if (!_controller.position.atEdge) {
      return;
    }

    log('scroll controller @ ${_controller.position}');

    final success = await populate(widget.loadSizeInterval, offset: _offset);

    if (success) {
      _offset += widget.loadSizeInterval;
    } else {
      _loadedMaxItems = true;
    }
  }
}
