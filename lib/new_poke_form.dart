import 'package:flutter/material.dart';
import 'poke_model.dart';

class AddPokeFormPage extends StatefulWidget {
  @override
  _AddPokeFormPageState createState() => new _AddPokeFormPageState();
}

class _AddPokeFormPageState extends State<AddPokeFormPage> {
  /*
  Other TextEditingControllers have been deleted as they are
  unnecesary in pressence of an API
  Also a FocusNode has been added to style the TextField
  when the user is writing something
  */
  TextEditingController nameController = new TextEditingController();
  FocusNode focus = new FocusNode();

  //This updates the FocusScope
  void updateFocus() {
    setState(() => FocusScope.of(context).requestFocus(focus));
  }

  void submitPokemon(BuildContext context) {
    if (nameController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(
        new SnackBar(
          backgroundColor: Colors.redAccent,
          content: new Text('Pokemons neeed names!', style: TextStyle(color: Colors.white),)
        )
      );
    } else {
      var newPokemon = new Pokemon(nameController.text);
      Navigator.of(context).pop(newPokemon);
    }
  }

  /*
  The colors has been changed to match the Pokemon color scheme
  */
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add a new Pokemon', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: new Container(
        decoration: new BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/background_new.jpg"), fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.yellow, BlendMode.darken)
          )
        ),
        child: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
          child: new Column(children: [
            new Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: new TextField(
                onTap: updateFocus,
                focusNode: focus,
                controller: nameController,
                decoration: new InputDecoration(
                  //The line that inverses the input has been deleted
                  fillColor: Colors.redAccent,
                  labelText: 'Name / ID [1-893]',
                  labelStyle: TextStyle(color: focus.hasFocus ? Colors.red : Colors.white),
                  focusedBorder: const UnderlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Builder(
                builder: (context) {
                  return new RaisedButton(
                    color: Colors.redAccent,
                    onPressed: () => submitPokemon(context),
                    child: new Text('Add Pokemon', style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
