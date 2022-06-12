import 'package:flutter/material.dart';
import 'package:pokedex/screens/home.dart';

void main() {
  runApp(const PokeDex());
}

class PokeDex extends StatelessWidget {
  const PokeDex({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.red),
      home: const HomeScreen(),
    );
  }
}
