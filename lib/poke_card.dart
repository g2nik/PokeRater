import 'package:flutter/material.dart';
import 'poke_detail_page.dart';
import 'poke_model.dart';

/*
This function now features 2 brand new parameters, which are index and callback()
which will be used in case the pokemon is deleted
*/
class PokeCard extends StatefulWidget {
  PokeCard({this.index, this.pokemon, this.callback});

  int index;
  Pokemon pokemon;
  Function callback;

  @override
  _PokeCardState createState() => _PokeCardState(pokemon);
}

//I deleted renderUrl because i will be using the url from the pokemon
class _PokeCardState extends State<PokeCard> {
  _PokeCardState(this.pokemon);

  Pokemon pokemon;

  void initState() {
    super.initState();
    renderPokePic();
  }

  void renderPokePic() async {
    await pokemon.load();
    setState(() {});
  }

  Widget get pokeImage {
    //I replaced BoxDecoration with just an Image
    var pokeAvatar = new Hero(
      tag: pokemon,
      child: new Container(
        width: 100.0,
        height: 100.0,
        child: Image.network(pokemon.imageUrl ?? "")
      ),
    );
    
    //I replaced BoxDecoration with a pokeball image
    var placeholder = new Container(
      width: 100.0,
      height: 100.0,
      child: new Image.asset("assets/pokeball.png"),
    );

    var crossFade = new AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: pokeAvatar,
      //And i made this check the pokemon.imageUrl
      crossFadeState: pokemon.imageUrl == null
      ? CrossFadeState.showFirst
      : CrossFadeState.showSecond,
      duration: new Duration(milliseconds: 1000),
    );

    return crossFade;
  }

  
  /*
  I made the card shorter and gave it some opacity, it now displays the name,
  the rating and a clear icon used to delete the pokemon from the list
  */
  Widget get pokeCard {
    return new Positioned(
      right: 0.0,
      child: new Container(
        width: 250,
        height: 115,
        child: new Card(
          color: Colors.redAccent.withOpacity(0.7),
          child: new Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new Text(pokemon.name, style: TextStyle(color: Colors.white, fontSize: 25)),
                    new Row(
                      children: <Widget>[
                        //I made the star look amber and deleted the location
                        new Icon(Icons.star, color: Colors.amber),
                        new Text(' ${pokemon.rating}/10', style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 50,
                  child: IconButton(
                    icon: Icon(Icons.clear, size: 50, color: Colors.white),
                    //This is the function that returns the index of the deleted pokemon
                    onPressed: () => this.widget.callback(widget.index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  showPokeDetailPage() async {
    /*
    First i check two cases:
    1: Pokemon's data has been loaded
    2: Pokemon is incorrect (it doesn't exits)

    Whether the case is 1 or 2, i await for the Detail Page to load and close,
    after which i uset setState() to rebuild the widget in case the rating
    has been updated
    */    
    if (pokemon.loaded || !pokemon.correct) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return new PokeDetailPage(pokemon);
      }));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () => showPokeDetailPage(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: new Container(
          height: 115.0,
          child: new Stack(
            children: <Widget>[
              pokeCard,
              new Positioned(top: 7.5, child: pokeImage),
            ],
          ),
        ),
      ),
    );
  }
}
