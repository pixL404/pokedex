import 'package:flutter/material.dart';
import 'package:pokedex/classes/pokemon.dart';
import 'package:pokedex/components/sprite_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Pokemon?> _pokemon;

  @override
  void initState() {
    super.initState();

    _pokemon = [];
    populate();
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
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) => Card(
                child: _pokemon[index] != null
                    ? SpriteWidget(
                        sprite: _pokemon[index]!.sprites[0],
                      )
                    : const Icon(Icons.error),
              ),
            ),
    );
  }

  void populate() async {
    var temp = <Pokemon?>[];
    temp.add(await Pokemon.fromIdentifier("bulbasaur"));
    temp.add(await Pokemon.fromIdentifier("charizard"));
    setState(() {
      _pokemon.addAll(temp);
    });
  }
}
