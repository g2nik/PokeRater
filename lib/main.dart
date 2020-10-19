import 'package:flutter/material.dart';
import 'poke_model.dart';
import 'dart:async';
import 'new_poke_form.dart';
import 'poke_list.dart';

/*
As noted in the imports i replaced all the dogs with pokemons
The words "dog" "pup" were replaced by "poke" or "pokemon/s"
*/

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //The following line hides the red banner that says "debug"
      debugShowCheckedModeBanner: false,
      title: 'PokeRater',
      theme: ThemeData(brightness: Brightness.dark),
      home: MyHomePage(
        title: 'PokeRater',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /*
  The list is called pokemons and they only need a name as other info
  related to that Pokemon will be fetched from an API
  */
  List<Pokemon> pokemons = []
    ..add(Pokemon("1"))
    ..add(Pokemon("Charmander"))
    ..add(Pokemon("147"))
    ..add(Pokemon("arcanine"))
    ..add(Pokemon("Agumon"))
    ..add(Pokemon("pikachu"))
    ..add(Pokemon("fletchinder"))
    ..add(Pokemon("groudon"));

  Future _showNewPokeForm() async {
    Pokemon newPokemon = await Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) {
      return AddPokeFormPage();
    }));
    print(newPokemon);
    if (newPokemon != null) pokemons.add(newPokemon);
    /*
    I added a setState() so that after adding a new item to the list the widget updates
    and the user has visual confirmation of his actions
    */
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var key = new GlobalKey<ScaffoldState>();
    return new Scaffold(
      key: key,
      appBar: new AppBar(
        /*
        I changed the title to "PokeRater" with a white font and made the appBar red
        The same is with icons and in almost every place of the app, which is
        to match the color scheme used in pokemon, which uses red, white and black
        */
        title: new Text(widget.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.add, color: Colors.white,),
            onPressed: _showNewPokeForm,
          ),
        ],
      ),
      
      /*
      I replaced the gradient background with an asset image and set it
      to cover the whole body
      */
      body: new Container(
        decoration: new BoxDecoration(image: DecorationImage(
          image: AssetImage("assets/background.jpg"), fit: BoxFit.cover),
        ),

        /*
        I added a method to pass as a parameter to PokeList because i wanted to
        be able to delete an element on the list and see the change right away
        It was not possible without a setState() on this specific widget, which is the
        grand-parent of the widget on which the deletion takes effect, being the
        structure as follows:

        1 grand-parent: MyHomePage (has list "pokemons" and method updatePokemons)
        2 parent: PokeList (connects grand-parent and child)
        3 child: PokeCard (when a pokemon is deleted it returns its index on the array)

        When the delete button is pressed the child passes to his parent the pokemon
        index and the parent calls updatePokemons() passing the index as a parameter
        updatePokemons() removes the pokemon at said index and rebuilds the widget
        */
        child: new Center(
          child: PokeList(pokemons, updatePokemons)
        )),
    );
  }

  void updatePokemons(int index) {
    setState(() => pokemons.removeAt(index));
  }
}
