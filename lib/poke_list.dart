import 'package:flutter/material.dart';
import 'poke_model.dart';
import 'poke_card.dart';

/*
I added a mainCallback() function as a parameter so the child (PokeCard) and the grand-parent
(MyHomePage) can communicate
*/
class PokeList extends StatelessWidget {
  PokeList(this.pokemons, this.mainCallback);
  List<Pokemon> pokemons;
  final Function mainCallback;

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  ListView _buildList(context) {
    return new ListView.builder(
      itemCount: pokemons.length,
      itemBuilder: (context, int index) {
        /*
        I added the index and the callback function so that the child widget (PokeCard)
        knows which index to return if the delete function is deleted
        It passes the index back to the parent with the callback() function
        */
        return PokeCard(index: index, pokemon: pokemons[index], callback: callback);
      },
    );
  }

  void callback(int index) => mainCallback(index);
}
